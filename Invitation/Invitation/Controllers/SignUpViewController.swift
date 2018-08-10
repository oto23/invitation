//
//  Sign Up.swift
//  Invitation
//
//  Created by Macbook pro on 7/25/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuth.FIRUser

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else
        {
            self.showMessage(messageToDisplay: "First name is required")
            return
            
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else
        {
            self.showMessage(messageToDisplay: "Last name is required")
            return
            
        }
        guard let userEmail = emailTextField.text, !userEmail.isEmpty else
        {
            self.showMessage(messageToDisplay: "Email is required")
            return
            
        }
        
        guard let username = usernameTextField.text, !username.isEmpty else
        {
            self.showMessage(messageToDisplay: "Username name is required")
            return
            
        }
        
        guard let password = passwordTextField.text, !password.isEmpty
            else{
                
                
            self.showMessage(messageToDisplay: "Password is required")
                
            return
        }
        guard let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty
            else{
                
                
                self.showMessage(messageToDisplay: "Repeat password is required")
                
                return
        }
        
            if password != repeatPassword
            {
                self.showMessage(messageToDisplay: "Passwords don't match")
                return
            }
        
        
        Auth.auth().createUser(withEmail:userEmail, password: password) { (user, error) in
            
           
            if let error = error
            {
                print(error.localizedDescription)
                self.showMessage(messageToDisplay: error.localizedDescription)
                return
            }
            if let user = user {
                
                var databaseReferance: DatabaseReference!
                databaseReferance = Database.database().reference()
                let userDetails: [String:String] = ["FirstName":firstName, "LastName":lastName, "Username": username]
                
                
                
                
            databaseReferance.child("users").child(user.user.uid).setValue(["userDetails": userDetails])
                
                
                
                
            user.user.sendEmailVerification(completion:nil)
                self.showMessage(messageToDisplay: "We have sent you an email message. Please check your email and follow the link to verify")
                
                let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    let  appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = signInPage
                
                
                
                
                
            }
        }
    
    
    
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    
    
    public func showMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        { (action: UIAlertAction!) in
            
            print("OK button tapped")
        }
        alertController.addAction(OKAction)
        self.present(alertController,animated: true, completion: nil)
    }
}

