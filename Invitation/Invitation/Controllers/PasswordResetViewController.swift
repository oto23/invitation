//
//  PasswordResetViewController.swift
//  Invitation
//
//  Created by Macbook pro on 7/28/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordResetViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailAdressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailAdressTextField.resignFirstResponder()
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true)
        self.view.endEditing(true)
    }
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
        guard let emailAdress = emailAdressTextField.text, !emailAdress.isEmpty else{return}
        Auth.auth().sendPasswordReset(withEmail: emailAdress) { (error) in
            if error != nil{
                self.showMessage(messageToDisplay: (error?.localizedDescription)!)
                return
                
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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
