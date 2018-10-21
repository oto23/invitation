//
//  InvitedFriendsViewController.swift
//  Invitation
//
//  Created by Macbook pro on 8/20/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class InvitedFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    
    
    
    var post: Post!
    var user: User!
    var postservice: PostService!
    var invitedFriends = [User]()
    var list2 = [String]()
    
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        for uid in list2{
            let ref = Database.database().reference().child("users").child(uid)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                    guard let user = User(snapshot: snapshot) else {
                        return assertionFailure("Failed to create user using snapshot")
                    }
                   
                    self.invitedFriends.append(user)
                    //                self.userList1.append(user.username!)
                
                
                DispatchQueue.main.async {
                    self.friendsCellView.reloadData()
                }
                
            }
        
        

    }
            
        friendsCellView.delegate = self
        friendsCellView.dataSource = self
//        print("list 222222\(list2)")
        

        // Do any additional setup after loading the view.
    }
 
    @IBOutlet weak var friendsCellView: UITableView!
    
//    func getUsers(){
//        for uid in list2{
//            let userRef = Database.database().reference().child("users").child(uid)
//            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                guard let user = User(snapshot: snapshot) else {
//                    fatalError("failed to create a user from the snapshot")
//                }
//                self.invitedFriends.append(user)
//
//
//            })
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedFriends.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = invitedFriends[indexPath.row]
        cell.textLabel?.text = user.username
        cell.textLabel?.textColor = #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.02352941176, alpha: 1)
//        cell.backgroundColor = UIColor.darkGray
        return cell
    }
}
