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
        print("dragged")

    }

}

