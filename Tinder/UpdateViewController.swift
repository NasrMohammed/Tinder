//
//  UpdateViewController.swift
//  Tinder
//
//  Created by Nasr Mohammed on 6/20/19.
//  Copyright © 2019 Nasr Mohammed. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userGenderSwitch: UISwitch!
    
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(isFemale, animated: false)
        }
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestedGenderSwitch.setOn(isInterestedInWomen, animated: false)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFileObject {
            photo.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.profileImageView.image = image
                    }
                }
            }
        }
       // createWomen()
    }
    
    func createWomen() {
        let imageUrls = ["https://vignette.wikia.nocookie.net/simpsons/images/9/95/Maude_Flanders.png/revision/latest?cb=20171127151808", "https://vignette.wikia.nocookie.net/simpsons/images/9/95/Maude_Flanders.png/revision/latest?cb=20171127151808", "https://vignette.wikia.nocookie.net/simpsons/images/9/95/Maude_Flanders.png/revision/latest?cb=20171127151808"]
        var counter = 0
        
        for imageUrl in imageUrls {
            counter += 1
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFileObject(name: "photo.png", data: data)
                    
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    user.password = "abc123"
                    user["isFemale"] = true
                    user["isInterestedInWomen"] = false
                    
                    user.signUpInBackground { (success, error) in
                        if success {
                            print("women user created!")
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func updateImageTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func updateTapped(_ sender: Any) {
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedGenderSwitch.isOn
        
        if let image = profileImageView.image {
            if let imageData = image.pngData() {
                PFUser.current()?["photo"] = PFFileObject(name: "profile.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        var errorMessage = "Update Failed - Try Again"
                        
                        if let newError = error as NSError? {
                            if let detailError = newError.userInfo["error"] as? String {
                                errorMessage = detailError
                            }
                        }
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                    } else {
                        print("Update Successful")
                        
                        self.performSegue(withIdentifier: "updateToSwipeSegue", sender: nil)
                    }
                })
            }
        }
       // UIImage.pngData(profileImageView.image)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
