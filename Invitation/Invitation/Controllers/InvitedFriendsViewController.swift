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
    var list2 = [User]()
    
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsCellView.delegate = self
        friendsCellView.dataSource = self
       
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getInvitedFriends{ success in
            self.getFriendsToDisplay()
        }
    }
    @IBOutlet weak var friendsCellView: UITableView!
    
    func getInvitedFriends(completion: @escaping (Bool) -> ()){
        let ref = Database.database().reference().child("open_invites")
//        print(ref)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let snapshotsOfInvites = snapshot.children.allObjects as? [DataSnapshot] else {
                return assertionFailure("Failed to get following")
            }
            
            let dg = DispatchGroup()
            
            for snap in snapshotsOfInvites{
                //                guard let user = User(snapshot: snap) else {
                //                    return assertionFailure("Failed to create user")
                //                }
                
                let inviteId = snap.key
        
//                print(inviteId)
                
                dg.enter()
                
                let userRef = Database.database().reference().child("open_invites").child(inviteId).child("invited_friends")
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let snapOfInvitedFriends = snapshot.children.allObjects as? [DataSnapshot] else{
                        return assertionFailure("failed to get invited friends")
                    }
                    
                    for snap in snapOfInvitedFriends{
//                        print("this is snap\(snap)")
//                        print("this is key\(snap.key), this is value\(snap.value)")
                        let userId = snap.key
                        dg.leave()
                    
                   

                    
//                    print("aaaaaaaaa\(snapOfInvitedFriends)")
                        dg.enter()
                        let userRef = Database.database().reference().child("users").child(userId)
                        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            guard let user = User(snapshot: snapshot) else {
                                fatalError("failed to create a user from the snapshot")
                            }
                            
                            self.invitedFriends.append(user)
                            dg.leave()
                           
                            
                            
                        
                        })
                        
                    }
                    
                })
                
                
            }
            dg.notify(queue: DispatchQueue.main, execute: {
                completion(true)
            })
        }
    }
    
    func getFriendsToDisplay(){
        for friend in invitedFriends{
//            print(friend.username)
            if friend == User.current{
                list2.append(friend)
            }
            
        }
    self.friendsCellView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = invitedFriends[indexPath.row]
        cell.textLabel?.text = user.username
        return cell
        
    }
    
}
