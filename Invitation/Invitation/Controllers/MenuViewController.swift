//
//  MenuViewController.swift
//  Invitation
//
//  Created by Nika Talakhadze on 8/7/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let titleArrAY = ["Search Friends", "Personal Info",]
    
  
    

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
            let storyboard1 = UIStoryboard(name: "Users", bundle: nil)
            let initVC = storyboard1.instantiateInitialViewController()
            self.present(initVC!, animated: true)
            
        case 1:break
            
        default:
            break
        }
    }
  
    
}
