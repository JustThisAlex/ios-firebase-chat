//
//  Models.swift
//  Firebase Chat
//
//  Created by Alexander Supe on 26.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import MessageKit

struct KitMessage: MessageType {
    var sentDate: Date
    var sender: SenderType = Sender(senderId: "", displayName: "")
    var messageId: String = UUID().uuidString
    var kind: MessageKind
}

struct Message: Codable {
    var text: String
    let sentDate: Date
}

struct Room: Codable {
    var messages: [Message]
    let id: UUID
    var title: String
}
