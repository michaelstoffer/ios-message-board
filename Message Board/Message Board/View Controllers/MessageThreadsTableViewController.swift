//
//  MessageThreadsTableViewController.swift
//  Message Board
//
//  Created by Michael Stoffer on 5/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class MessageThreadsTableViewController: UITableViewController {
    
    // MARK: - @IBOutlets and Properties
    @IBOutlet var threadNameTextField: UITextField!

    var messageThreadController: MessageThreadController = MessageThreadController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageThreadController.messageThreads.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadsCell", for: indexPath)

        let messageThread = self.messageThreadController.messageThreads[indexPath.row]
        cell.textLabel?.text = messageThread.title

        return cell
    }
    
    
    // MARK: - Table view data source
    @IBAction func createThread(_ sender: UITextField) {
        guard let title = self.threadNameTextField.text else { return }
        
        self.messageThreadController.createMessageThread(withTitle: title) { (error) in
            if let error = error {
                NSLog("Error creating our Message Thread: \(error)")
            }
            
            DispatchQueue.main.async {
                self.threadNameTextField.text = nil
                self.tableView.reloadData()
            }
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMessageThreadDetail" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let messageThreadDetailVC = segue.destination as? MessageThreadDetailTableViewController else { return }
            
            let messageThread = self.messageThreadController.messageThreads[indexPath.row]
            messageThreadDetailVC.messageThread = messageThread
            messageThreadDetailVC.messageThreadController = self.messageThreadController
        }
    }
}
