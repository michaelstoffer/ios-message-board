//
//  MessageThread.swift
//  Message Board
//
//  Created by Michael Stoffer on 5/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

class MessageThread: Equatable, Codable {
    var title: String
    var identifier: String
    var messages: [MessageThread.Message]
    
    init(title: String, identifier: String = UUID().uuidString, messages: [MessageThread.Message] = []) {
        self.title = title
        self.identifier = identifier
        self.messages = messages
    }
    
    static func == (lhs: MessageThread, rhs: MessageThread) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.title == rhs.title
    }
    
    struct Message: Equatable, Codable {
        var text: String
        var sender: String
        var timestamp: Date
        
        init(text: String, sender: String, timestamp: Date = Date()) {
            self.text = text
            self.sender = sender
            self.timestamp = timestamp
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        let messagesDictionaries = try container.decodeIfPresent([String: Message].self, forKey: .messages)
        
        let messages = messagesDictionaries?.compactMap({ $0.value }) ?? []
        
        self.title = title
        self.identifier = identifier
        self.messages = messages
    }
}
