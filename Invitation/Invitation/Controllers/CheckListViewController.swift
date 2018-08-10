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
    
    
    var listOfSelectedFriends = [String]()
    
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
        cell.textLabel?.text = user
        
        
//        let label = cell.viewWithTag(1000) as! UILabel
//        label.text = "Name and last name"
//
//        let secondlabel = cell.viewWithTag(100) as! UILabel
//        secondlabel.text = "request sent"
//
        return cell
    }
    
    
}
