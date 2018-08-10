//
//  MainPageViewController.swift
//  Invitation
//
//  Created by Macbook pro on 8/10/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class MainPageViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBAction func BackButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let displayFriendList = storyboard.instantiateViewController(withIdentifier:"NewViewController") as! NewViewController
        self.present(displayFriendList, animated: true, completion: nil)
        
        
    }
    
    @IBAction func LogoutButton(_ sender: UIBarButtonItem) {
        do{
            
            Analytics.logEvent("signout", parameters: nil)
            for userInfo in (Auth.auth().currentUser?.providerData)!
            {
                if userInfo.providerID == "facebook.com"
                {
                    FBSDKLoginManager().logOut()
                    break
                }
            }
            
            
            
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let signInPage = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let  appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
            
            
            
            
        }catch{
            self.showMessage(messageToDisplay: "Could not sign out at this time")
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let currentUser = Auth.auth().currentUser
        var databaseReferance: DatabaseReference!
        databaseReferance = Database.database().reference()
        databaseReferance.child("users").child((currentUser?.uid)!).child("userDetails").observeSingleEvent(of: .value) { (data) in
            let userDetailsData = data.value as? NSDictionary
            let firstName = userDetailsData?["FirstName"] as? String ?? ""
            let lastName = userDetailsData!["LastName"] as? String ?? ""
            let username = userDetailsData!["Username"] as? String ?? ""
            
            self.welcomeLabel.text = "First Name:\(firstName)"
            self.LastNameLabel.text = "Last Name: \(lastName)"
            self.usernameLabel.text = "Username: \(username)"
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
