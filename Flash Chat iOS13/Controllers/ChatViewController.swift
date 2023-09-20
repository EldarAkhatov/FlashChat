//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.hidesBackButton = true
        navigationItem.title = Constants.appName

        tableView.register(UINib(
            nibName: Constants.cellNibName,
            bundle: nil
            ), forCellReuseIdentifier: Constants.cellIdentifier
        )
        
        loadMessages()
    }
    
    func loadMessages() {
        
        
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { (querySnapshot, err) in
           
            self.messages = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let firestoreData = doc.data()
                        if let sender = firestoreData[Constants.FStore.senderField] as? String, let message = firestoreData[Constants.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: message)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(
                data: [
                    Constants.FStore.senderField: messageSender,
                    Constants.FStore.bodyField: messageBody,
                    Constants.FStore.dateField: Date().timeIntervalSince1970
                ]
            ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added successfully")
                }
            }
        }
        
        messageTextfield.text = ""
        
    }
        
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
        
    }
    
}


extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        return cell
    }
}


extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
