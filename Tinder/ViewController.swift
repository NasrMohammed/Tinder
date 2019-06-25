//
//  ViewController.swift
//  Tinder
//
//  Created by Nasr Mohammed on 5/31/19.
//  Copyright © 2019 Nasr Mohammed. All rights reserved.
//

import UIKit
import Parse
import SYSegmentedControl

class ViewController: UIViewController {
    
    var displayUserID = ""
    @IBOutlet weak var matchImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gesturerecognizer:)))
        matchImageView.addGestureRecognizer(gesture)
        
        updateImage()
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let point = geoPoint {
                PFUser.current()?["location"] = point
                PFUser.current()?.saveInBackground()
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @objc func wasDragged(gesturerecognizer: UIPanGestureRecognizer) {
        let labelPoint = gesturerecognizer.translation(in: view)
        matchImageView.center = CGPoint(x: view.bounds.width/2 + labelPoint.x, y: view.bounds.height/2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width / 2 - matchImageView.center.x
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale =  min(100 / abs(xFromCenter), 1)
        
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        matchImageView.transform = scaledAndRotated
        
        
        // print(swipeLabel.center.x)
        if gesturerecognizer.state == .ended {
            
            var acceptedOrRejected = ""
            
            if matchImageView.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
                acceptedOrRejected = "rejected"
            }
            if matchImageView.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" && displayUserID != "" {
                PFUser.current()?.addUniqueObject(displayUserID, forKey: acceptedOrRejected)
                PFUser.current()?.saveInBackground(block: { (success, Error) in
                    if success {
                        self.updateImage()
                    }
                })
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            
            matchImageView.transform = scaledAndRotated
            
            
            matchImageView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            
            
        }
    }
    
    func updateImage() {
        if let query = PFUser.query() {
            
            if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] {
                query.whereKey("isFemale", equalTo: isInterestedInWomen)
            }
            
            if let isFemale = PFUser.current()?["isFemale"] {
                query.whereKey("isInterestedInWomen", equalTo: isFemale)
            }
            
            var ignoredUsers : [String] = []
            
            if let acceptedUsers =  PFUser.current()?["accedpted"] as? [String] {
                ignoredUsers += acceptedUsers
            }
            
            if let rejectedUsers =  PFUser.current()?["rejected"] as? [String] {
                ignoredUsers += rejectedUsers
            }
            
            query.whereKey("objectId", notContainedIn: ignoredUsers)
            
            if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint {
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geoPoint.latitude - 1, longitude: geoPoint.longitude - 1), toNortheast: PFGeoPoint(latitude: geoPoint.latitude + 1, longitude: geoPoint.longitude + 1))
            }
            query.limit = 1
            
            query.findObjectsInBackground { (objects, error) in
                if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            if let imageFile = user["photo"] as? PFFileObject {
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let imageData = data {
                                        self.matchImageView.image = UIImage(data: imageData)
                                        if let objectID = object.objectId {
                                            self.displayUserID = objectID
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

