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
            self.messageThreads = self.messageThreads.sorted(by: { $0.title < $1.title })
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
            messageThread.messages = messageThread.messages.sorted(by: { $0.timestamp < $1.timestamp })
            completion(nil)
        }.resume()
    }
    
    func fetchMessageThreads(completion: @escaping (Error?) -> Void) {
        var url = MessageThreadController.baseURL
        url.appendPathExtension("json")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(NSError()); return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let messageThreadDictionaries = try jsonDecoder.decode([String: MessageThread].self, from: data)
                let messageThreads = Array(messageThreadDictionaries.values)
                self.messageThreads = messageThreads.sorted(by: { $0.title < $1.title })
                completion(nil)
            } catch {
                NSLog("Unable to decode data into object of type [MessageThread]: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
