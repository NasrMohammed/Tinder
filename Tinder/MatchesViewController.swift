//
//  MatchesViewController.swift
//  Tinder
//
//  Created by Nasr Mohammed on 6/24/19.
//  Copyright © 2019 Nasr Mohammed. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // how many cells are they?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    // what data are going in them
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)  as? MatchTableViewCell {
            cell.messageLabel.text = "You haven't received message yet"
            cell.profileImageView.image = images[indexPath.row]
            cell.recipientObjectId = userId[indexPath.row]
            cell.messageLabel.text = messages[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    var images : [UIImage] = []
    var userId : [String] = []
    var messages : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // check all the users that matches
        if let query = PFUser.query() {
            // get the users accepted
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            if let acceptedPeeps = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: acceptedPeeps)
                
                query.findObjectsInBackground { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["photo"] as? PFFileObject {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            if let image = UIImage(data: imageData) {
                                                if let objectID = theUser.objectId {
                                                    

                                                    // to login and see messages
                                                    let messagesQuery = PFQuery(className: "Message")
                                                    
                                                    messagesQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId as Any)
                                                    messagesQuery.whereKey("sender", equalTo: theUser.objectId as Any)
                                                    
                                                    messagesQuery.findObjectsInBackground(block: { (objects, error) in
                                                        var messagetext = "No message from this user."
                                                        if let objects = objects {
                                                            for message in objects  {
                                                                if let content = message["content"] as? String {
                                                                    messagetext = content
                                                                    
                                                                }
                                                            }
                                                        }
                                                        self.messages.append(messagetext)
                                                        self.userId.append(objectID)
                                                        self.images.append(image)
                                                        self.tableView.reloadData()

                                                    })
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // use this logic to avoid stack viewcontroller
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
