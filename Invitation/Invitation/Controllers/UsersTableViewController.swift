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

class UsersTableViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var UsersTable: UITableView!
    let userCell = "UserCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    var ref = Database.database().reference().child("users")
    
    var userList: [String] = []
    var currentUserList = [String]()
    
    
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
                self.userList.append((user.username)!)
            }
            
            DispatchQueue.main.async {
                self.UsersTable.reloadData()
            }
            
        }
        
        setUpSearchBar()
        
        
        
    }
    
    private func setUpSearchBar(){
        searchBar.delegate = self
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == UsersTable{
            return currentUserList.count
        } else {
            return userList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        if tableView == UsersTable{
            cell.textLabel?.text = currentUserList[indexPath.row]
        } else {
            cell.textLabel?.text = userList[indexPath.row]
        }
        
        
        
        return cell
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        currentUserList = userList.filter({ (array:String) -> Bool in
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
}


//    func fetchUsers(){
//        refHandle = ref.child("Users").observe(.childAdded, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: AnyObject] else{return}
//                print(dictionary)
//                let user = User()
//                user.setValuesForKeys(dictionary)
//                self.userList.append(user)
//
//                DispatchQueue.main.async(execute: {
//
//
//                    self.tableView.reloadData()
//                } )
//
//
//
//
//        })
//    }


//}
