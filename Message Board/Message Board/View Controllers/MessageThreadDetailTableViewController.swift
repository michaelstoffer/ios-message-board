//
//  MessageThreadDetailTableViewController.swift
//  Message Board
//
//  Created by Michael Stoffer on 5/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class MessageThreadDetailTableViewController: UITableViewController {
    
    // MARK: - @IBOutlets and Properties
    var messageThread: MessageThread?
    var messageThreadController: MessageThreadController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.messageThread?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageThread!.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)

        let message = self.messageThread?.messages[indexPath.row]
        cell.textLabel?.text = message?.text
        cell.detailTextLabel?.text = message?.sender

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddMessage" {
            guard let messageDetailVC = segue.destination as? MessageDetailViewController else { return }
            
            messageDetailVC.messageThread = self.messageThread
            messageDetailVC.messageThreadController = self.messageThreadController
        } else if segue.identifier == "ToDetailMessage" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let messageDetailVC = segue.destination as? MessageDetailViewController else { return }
            
            let message = self.messageThread?.messages[indexPath.row]
            messageDetailVC.message = message
            messageDetailVC.messageThread = self.messageThread
            messageDetailVC.messageThreadController = self.messageThreadController
        }
    }
}
