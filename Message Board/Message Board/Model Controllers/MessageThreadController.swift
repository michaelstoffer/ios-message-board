//
//  MessageThreadController.swift
//  Message Board
//
//  Created by Michael Stoffer on 5/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

class MessageThreadController {
    var messageThreads: [MessageThread] = []
    
    static let baseURL = URL(string: "https://lambda-message-board.firebaseio.com/")!
    
    func createMessageThread(withTitle title: String, completion: @escaping (Error?) -> Void) {
        let messageThread = MessageThread(title: title)
        
        var url = MessageThreadController.baseURL
        url.appendPathComponent(messageThread.identifier)
        url.appendPathExtension("json")

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(messageThread)
        } catch {
            NSLog("Unable to encode data into object of type [MessageThread]: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            self.messageThreads.append(messageThread)
            completion(nil)
        }.resume()
    }
    
    func createMessage(messageThread: MessageThread, withText text: String, withSender sender: String, completion: @escaping (Error?) -> Void) {
        let message = MessageThread.Message(text: text, sender: sender)
        
        var url = MessageThreadController.baseURL
        url.appendPathComponent(messageThread.identifier)
        url.appendPathComponent("messages")
        url.appendPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(message)
        } catch {
            NSLog("Unable to encode data into object of type [MessageThread.Message]: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            
            messageThread.messages.append(message)
            completion(nil)
        }.resume()
    }
}
