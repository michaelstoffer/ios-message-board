//
//  MessageDetailViewController.swift
//  Message Board
//
//  Created by Michael Stoffer on 5/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    
    // MARK: - @IBOutlets and Properties
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var messageTextView: UITextView!
    
    var messageThread: MessageThread?
    var messageThreadController: MessageThreadController?
    var message: MessageThread.Message? {
        didSet {
            self.updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
        
    // MARK: - @IBActions and Methods
    @IBAction func sendMessage(_ sender: UIBarButtonItem) {
        guard let sender = self.nameTextField.text,
            let text = self.messageTextView.text,
            let messageThread = self.messageThread else { return }
        
        self.messageThreadController!.createMessage(messageThread: messageThread, withText: text, withSender: sender) { (_) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateViews() {
        guard let message = self.message, isViewLoaded else { return }
        
        self.nameTextField.text = message.sender
        self.messageTextView.text = message.text
    }
}
