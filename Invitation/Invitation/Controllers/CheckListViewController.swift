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
    
    @IBAction func check(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Users", bundle: nil)
        let userLists = storyboard.instantiateViewController(withIdentifier:"UsersTableViewController") as! UsersTableViewController
        self.present(userLists, animated: true, completion: nil)
        
        
     
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "Name and last name"
        
        let secondlabel = cell.viewWithTag(100) as! UILabel
        secondlabel.text = "request sent"
        
        return cell
    }
    
    
    
    
}
