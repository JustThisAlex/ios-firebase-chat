//
//  DetailViewController.swift
//  Firebase Chat
//
//  Created by Alexander Supe on 26.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class DetailViewController: MessagesViewController, MessagesDataSource, MessageInputBarDelegate, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    let contr = ChatController.shared
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let room = room else { return }
        inputBar.inputTextView.text = ""
        contr.createMessage(in: room.id, with: text) {
            self.contr.fetchRoom(in: room.id) { (room) in
                self.room = room
                self.messagesCollectionView.reloadData()
            }
        }
        
    }
    
    
    
    //MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        return Sender(id: "", displayName: "me")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let m = room?.messages[indexPath.section]
        let message = KitMessage(sentDate: m?.sentDate ?? Date(), kind: MessageKind.text(m?.text ?? ""))
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        room?.messages.count ?? 0
    }
    
    var room: Room?

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
