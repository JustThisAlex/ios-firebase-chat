//
//  Controller.swift
//  Firebase Chat
//
//  Created by Alexander Supe on 26.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class ChatController {
    static let shared = ChatController()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    func createRoom(messages: [Message], title: String) {
        let room = Room(messages: messages, id: UUID(), title: title)
        do {
                try db.collection("rooms").document("\(room.id)").setData(from: room)
            } catch let error {
                print("Error writing to Firestore: \(error)")
            }
    }
    
    func fetchRooms(completion: @escaping (([Room]?) -> ())) {
        var rooms = [Room]()
        db.collection("rooms").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: Room.self)
//                        document.data().compactMap {
//                            $0.value as? Room
//                        }
                    }
                    switch result {
                    case .success(let room):
                        if let room = room { rooms.append(room) }
                    case .failure(let error):
                        print("Error decoding: \(error)")
                    }
                    
                }
                completion(rooms)
            }
        }
    }
    
    func createMessage(in room: UUID, with message: String, completion: @escaping () -> ()) {
        let newMessage = Message(text: message, sentDate: Date())
        
        fetchRoom(in: room) { (room) in
            var newRoom = room
            newRoom.messages.append(newMessage)
            
            do {
                try self.db.collection("rooms").document("\(newRoom.id)").setData(from: newRoom)
            } catch let error {
                print("Error writing to Firestore: \(error)")
            }
            completion()
        }
    }
    
    func fetchRoom(in room: UUID, completion: @escaping ((Room) -> ())) {
        db.collection("rooms").document("\(room)").getDocument { (document, error) in
            let result = Result {
                try document.flatMap {
                    try $0.data(as: Room.self)
                }
            }
            switch result {
            case .success(let room):
                if let room = room {
                    completion(room)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding: \(error)")
            }
        }
    }
    
    func fetchMessages(in room: UUID, completion: @escaping (([Message]) -> ())) {
        fetchRoom(in: room) { (room) in
            completion(room.messages)
        }
    }
    
}
