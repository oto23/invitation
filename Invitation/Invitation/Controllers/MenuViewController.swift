//
//  MenuViewController.swift
//  Invitation
//
//  Created by Nika Talakhadze on 8/7/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let titleArrAY = ["","Search Friends", "Personal Info", "My Location", "Log out" ]
    
    
    
    
    @IBOutlet weak var menuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.delegate = self
        menuTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArrAY.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        cell.labelTitle.text = titleArrAY[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("")
        case 1:
            let storyboard1 = UIStoryboard(name: "Users", bundle: nil)
            let initVC = storyboard1.instantiateInitialViewController()
            self.present(initVC!, animated: true)
            
        case 2:
            let storyboard1 = UIStoryboard(name: "Login", bundle: nil)
            let initVC = storyboard1.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
            self.present(initVC, animated: true)
            
        case 3 :
            let storyboard1 = UIStoryboard(name: "myLocation", bundle: nil)
            let initVC = storyboard1.instantiateInitialViewController()
            self.present(initVC!, animated: true)
            
        case 4 :
            
            
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
            
        default:
            break
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
