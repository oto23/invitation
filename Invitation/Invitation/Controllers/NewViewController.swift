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


class NewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
   

    
    
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBAction func inviteButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Users", bundle: Bundle.main)
        let mapView = storyboard.instantiateViewController(withIdentifier:"UsersTableViewController") as! UsersTableViewController
        self.present(mapView, animated: true, completion: nil)
        
        
    }
    var listOfFollowers = [String]()
    var listOfFollowees = [String]()
    
    var listOfFriendsString = [String]()
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var reciever = [String]()
    

    
    @IBOutlet weak var friendsTableView: UITableView!
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchFollowers()
        fetchFollowees()

        findFriends()
        
        print("followers: \(listOfFollowers)")
        print("followees: \(listOfFollowees)")
        print("friends\(listOfFriendsString)")
        
//            for snap in snapshot.children {
//
//                let snap = snap as! DataSnapshot
////                guard let user = User(snapshot: snap) else {
////                    return assertionFailure("Failed to create user using snapshot")
////                }
//                let userId = snap.key
//                let newRef = Database.database().reference().child("users").child(userId)
//                newRef.observeSingleEvent(of: .value , with: { (userSnapshot) in
//                    guard let user = User(snapshot: userSnapshot) else {return}
////                    print(user.username)
//                    self.listOfFollowees.append(user.username!)
//                    print("folowees")
//                    print(self.listOfFollowees)
//                })
//
//
////                self.listOfFriendsString.append(user.username!)
//            }
    
//            ref2 = Database.database().reference().child("followers")
//            ref2.observeSingleEvent(of: .value) { (snapshot) in
//                for snap in snapshot.children {
//                    let snap = snap as! DataSnapshot
//                    //                guard let user = User(snapshot: snap) else {
//                    //                    return assertionFailure("Failed to create user using snapshot")
//                    //                }
//                    let userId = snap.key
//                    let newRef = Database.database().reference().child("users").child(userId)
//                    newRef.observeSingleEvent(of: .value , with: { (userSnapshot) in
//                        guard let user = User(snapshot: userSnapshot) else {return}
////                        print(user.username)
//
//                        self.listOfFollowers.append(user.username!)
//                        print("followers")
//                        print(self.listOfFollowers)
//                    })
//                }
////                DispatchQueue.main.async {
////                    self.findFriends()
////
////                }
//            }
        
            
            
        
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
//        setUpSearchBar()
        friendsTableView.allowsMultipleSelection = true
    }
    
    func fetchFollowees() {
        guard let currentUID = User.current.uid else {return}
        print(currentUID)
        
        ref = Database.database().reference().child("following").child(currentUID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                return assertionFailure("Failed to get following")
            }
            
            for snap in snapshots {
                //                guard let user = User(snapshot: snap) else {
                //                    return assertionFailure("Failed to create user")
                //                }
                
                let userId = snap.key
                print(userId)
                
                let userRef = Database.database().reference().child("users").child(userId)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let user = User(snapshot: snapshot)
                    //                    guard let dict = snapshot.value as? [String: Any],
                    //                          let userDetailsDict = dict["userDetails"] as? [String: Any],
                    //                          let username = userDetailsDict["Username"] as? String else {
                    //                            return assertionFailure("Failed to get username")
                    //                    }
                    
                    // Append username in listOfFollowees array
                    //                    self.listOfFollowees.append(username)
                    guard let username = user?.username else { return }
                    
                    self.listOfFollowees.append(username)
                    
                    
                    print("Followees: \(self.listOfFollowees)")
                    
                })
                
            }
        }
        
    }
    
    func fetchFollowers() {
        guard let currentUID = User.current.uid else {return}
        ref2 = Database.database().reference().child("followers").child(currentUID)
        ref2.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                return assertionFailure("Failed to get following")
            }
            
            
            for snap in snapshots {
                
                let userId = snap.key
                print(userId)
                
                let userRef = Database.database().reference().child("users").child(userId)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let user = User(snapshot: snapshot)
                    
                    guard let username = user?.username else { return }
                    
                    self.listOfFollowers.append(username)
                    
                    print("Followers: \(self.listOfFollowers)")
                    
                })
                
            }
        }
        
    }
    
    func findFriends() {
        for user in self.listOfFollowees{
//            print("this is user:\(user)")
            for user1 in self.listOfFollowers{
//                print("this is user:\(user1)")
                if user == user1{
                    self.listOfFriendsString.append(user1)
                    print("friends")
                    print(listOfFriendsString)
                    
                }
            }
        }
        self.friendsTableView.reloadData()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        print(listOfFriendsString)
        return (listOfFriendsString.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = listOfFriendsString[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.02352941176, alpha: 1)
        cell.backgroundColor = UIColor.darkGray
        return (cell)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(listOfFriends[indexPath.row])
        
        // 1. preparing the data to send
//        reciever.append(listOfFriends[indexPath.row])
        
        // 2. change the ui of the cell
        let cell = self.friendsTableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
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
            
            

        
        

    
    
    


