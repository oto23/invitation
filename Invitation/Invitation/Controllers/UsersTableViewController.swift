//
//  UsersTableViewController.swift
//  Invitation
//
//  Created by Macbook pro on 7/31/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UsersTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    var userList = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        fetchUsers()
        
        

    
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        cell.textLabel?.text = userList[indexPath.row].username
        
        
        
        return cell
    }
    func fetchUsers(){
        refHandle = ref.child("Users").observe(.childAdded, with: { (DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String: AnyObject]{
                print(dictionary)
                let user = User()
                user.setValuesForKeys(dictionary)
                self.userList.append(user)
                
                DispatchQueue.main.async(execute: {
                    
                    
                    self.tableView.reloadData()
                } )
            }
            
            
            
        })
    }


}
