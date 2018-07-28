//
//  MainPageViewController.swift
//  Invitation
//
//  Created by Macbook pro on 7/26/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import FirebaseAuth
class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
         try Auth.auth().signOut()
            
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let  appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
            
            
            
    
        }catch{
            self.showMessage(messageToDisplay: "Could not sign out at this time")
            
        }
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
