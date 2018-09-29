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

    // MARK: - VARS

    var post: Post!

    var listOfSelectedFriends = [User]() {
        didSet {
            listOfFriendStatus = listOfSelectedFriends.reduce(into: [String: Post.InvitedUserStatus](), { (dict, aUser) in
                dict[aUser.uid!] = Post.InvitedUserStatus.awaitingResponse
            })
        }
    }

    var listOfFriendStatus: [String: Post.InvitedUserStatus] = [:]

    // MARK: - RETURN VALUES

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSelectedFriends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as! FriendTableViewCell
        let user = listOfSelectedFriends[indexPath.row]
        
        //username
        cell.labelUsername.text = user.username

        //status and background color
        if let userStats = listOfFriendStatus[user.uid!] {
            cell.labelSubtitle.text = userStats.title
            cell.backgroundColor = userStats.color.withAlphaComponent(0.15)
        }
        
        //image
        cell.configure(image: user.imageUrl)
        
        return cell
    }

    // MARK: - METHODS

    // MARK: - IBACTIONS

    @IBAction func displayButton(_ sender: Any) {
        //        let storyboard = UIStoryboard(name: "MapLocation", bundle: Bundle.main)
        //        let mapView = storyboard.instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
        //        self.present(mapView, animated: true, completion: nil)
        //
        print(listOfSelectedFriends)
    }

    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register the friend cell
        tableView.register(
            FriendTableViewCell.cellNib,
            forCellReuseIdentifier: FriendTableViewCell.identifier
        )

        PostService.observeFriendStatuses(for: self.post) { (newStatuses) in
            guard let newStatuses = newStatuses else {
                return
            }

            self.listOfFriendStatus = newStatuses
            self.tableView.reloadData()
        }
    }
}
