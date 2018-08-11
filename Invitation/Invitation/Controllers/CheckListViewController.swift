//
//  CheckListViewController.swift
//  Invitation
//
//  Created by Nika Talakhadze on 7/28/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

class CheckListViewController: UITableViewController {
    
    
    var listOfSelectedFriends = [User]() {
        didSet {
            
            listOfFriendStatus = listOfSelectedFriends.reduce([String: Int]()) { (dict, aUser) -> [String: Int] in
                var dictCopy = dict
                dictCopy[aUser.uid!] = 0
                
                return dictCopy
            }
        }
    }
    var listOfFriendStatus: [String: Int] = [:]
    
    @IBAction func displayButton(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "MapLocation", bundle: Bundle.main)
//        let mapView = storyboard.instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
//        self.present(mapView, animated: true, completion: nil)
//
        print(listOfSelectedFriends)
        }
        
        
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSelectedFriends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath)
        let user = listOfSelectedFriends[indexPath.row]
        cell.textLabel?.text = user.username
        
        if let userStats = listOfFriendStatus[user.uid!] {
            if userStats == 0 {
                
            } else if userStats == 1 {
                
            } else if userStats == 2 {
                
            }
        }
        
//        let label = cell.viewWithTag(1000) as! UILabel
//        label.text = "Name and last name"
//
//        let secondlabel = cell.viewWithTag(100) as! UILabel
//        secondlabel.text = "request sent"
//
        return cell
    }
    
    override func viewDidLoad() {
        
    }
    
    
}
