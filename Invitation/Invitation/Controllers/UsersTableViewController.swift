//
//  UsersTableViewController.swift
//  Invitation
//
//  Created by Macbook pro on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UsersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FindFriendsCellDelegate {
    
    @IBOutlet weak var UsersTable: UITableView!
    let userCell = "UserCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    var ref = Database.database().reference().child("users")
    
    var userList: [User] = []
    var currentUserList = [String]()
    var userList1: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        ref.observe(.childAdded, with: {snap in
        //            guard let username = snap.value as? String else{ return }
        //            print("12")
        //            self.userList.append(username)
        //            print("user appended")
        //            let row = self.userList.count - 1
        //            let indexPath = IndexPath(row: row, section: 0)
        //            self.tableView.insertRows(at: [indexPath], with: .top)
        //        })
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let snap = snap as! DataSnapshot
                guard let user = User(snapshot: snap) else {
                    return assertionFailure("Failed to create user using snapshot")
                }
                print("Username: \(user.username)")
                self.userList.append(user)
                self.userList1.append(user.username!)
            }
            
            DispatchQueue.main.async {
                self.UsersTable.reloadData()
            }
            
        }
        
        
        
        UsersTable.delegate = self
        UsersTable.dataSource = self
        setUpSearchBar()
    }
    
    private func setUpSearchBar(){
        searchBar.delegate = self
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userList1.count
        }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsCell", for: indexPath) as! FindFriendsCell
        cell.delegate = self 
        if tableView == UsersTable{
            cell.textLabel?.text = userList1[indexPath.row]
        }
        let user = userList[indexPath.row]
        
        //        cell.usernameLabel.text = user.username
        cell.requestButton.isSelected = user.isFollowed
        
        
        
        return cell
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        currentUserList = userList1.filter({ (array:String) -> Bool in
            if array.contains(searchBar.text!){
                print(searchBar.text)
                return true
            } else {
                return false
            }
        })
        
        UsersTable.reloadData()
        }
    

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
    
}

    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell) {
        guard let indexPath = UsersTable.indexPath(for: cell) else { return }
        
        followButton.isUserInteractionEnabled = false
        var followee = userList[indexPath.row]
        
        FriendsService.setIsFollowing(!followee.isFollowed, fromCurrentUserTo: followee) { (success) in
            defer {
                followButton.isUserInteractionEnabled = true
            }
            
            guard success else { return }
            
            followee.isFollowed = !followee.isFollowed
            self.UsersTable.reloadRows(at: [indexPath], with: .none)
        }
    }
}





