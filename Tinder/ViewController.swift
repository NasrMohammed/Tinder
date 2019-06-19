//
//  ViewController.swift
//  Tinder
//
//  Created by Nasr Mohammed on 5/31/19.
//  Copyright © 2019 Nasr Mohammed. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var swipeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gesturerecognizer:)))
        swipeLabel.addGestureRecognizer(gesture)
    }

    @objc func wasDragged(gesturerecognizer: UIPanGestureRecognizer) {
       let labelPoint = gesturerecognizer.translation(in: view)
        swipeLabel.center = CGPoint(x: view.bounds.width/2 + labelPoint.x, y: view.bounds.height/2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width / 2 - swipeLabel.center.x

        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale =  min(100 / abs(xFromCenter), 1)
        
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        swipeLabel.transform = scaledAndRotated
        
        
        // print(swipeLabel.center.x)
        if gesturerecognizer.state == .ended {
            if swipeLabel.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
            }
            if swipeLabel.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            
            swipeLabel.transform = scaledAndRotated

            
            swipeLabel.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            
            
        }
    }

}

