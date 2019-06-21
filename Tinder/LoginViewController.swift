//
//  LoginViewController.swift
//  Tinder
//
//  Created by Nasr Mohammed on 6/19/19.
//  Copyright © 2019 Nasr Mohammed. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInSignUpButton: UIButton!
    @IBOutlet weak var changeLoginSignUpButton: UIButton!
    
    var signUpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.isHidden = true
    }
    
    @IBAction func loginSignupTapped(_ sender: Any) {
        if signUpMode {
            
            let user = PFUser()
            
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "Sign Up Failed - Try Again"
                    
                    if let newError = error as NSError? {
                        if let detailError = newError.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                } else {
                    print("Sign up Successful")
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                }
            })
            
        } else {
            if let username =  usernameTextField.text {
                if let password = passwordTextField.text {
                    PFUser.logInWithUsername(inBackground: username, password: password, block:  { (user, error) in
                        
                        if error != nil {
                            var errorMessage = "Log in Failed - Try Again"
                            
                            if let newError = error as NSError? {
                                if let detailError = newError.userInfo["error"] as? String {
                                    errorMessage = detailError
                                }
                            }
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                        } else {
                            print("Log in Successful")
                            self.performSegue(withIdentifier: "updateSegue", sender: nil)

                        }
                    })
                }
            }
            
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "updateSegue", sender: nil)
        }
    }
    @IBAction func changeLoginSiunupTapped(_ sender: Any) {
        if signUpMode {
            logInSignUpButton.setTitle("Log In", for: .normal)
            changeLoginSignUpButton.setTitle("Sign Up", for: .normal)
            
            signUpMode = false
        } else {
            logInSignUpButton.setTitle("Sign Up", for: .normal)
            changeLoginSignUpButton.setTitle("Log In", for: .normal)
            
            signUpMode = true
        }
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
