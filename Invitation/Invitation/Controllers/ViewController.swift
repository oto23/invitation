//
//  ViewController.swift
//  Invitation
//
//  Created by Macbook pro on 7/24/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var search: UISearchBar!
    
    @IBAction func inviteButton(_ sender: Any) {
        
        
    }
    
    let listOfFriends = ["Sam", "Niko", "Oto"]
    
    var reciever = [String]()
    
    @IBOutlet weak var friendsTableView: UITableView!
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (listOfFriends.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = "Name and last name"
        cell.textLabel?.textColor = #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.02352941176, alpha: 1)
        cell.backgroundColor = UIColor.darkGray
        return (cell)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(listOfFriends[indexPath.row])
        
        // 1. preparing the data to send
        reciever.append(listOfFriends[indexPath.row])
        
        // 2. change the ui of the cell
        let cell = self.friendsTableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        friendsTableView.allowsMultipleSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: Any)
    {
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
            
            

        
        

    
    
    


