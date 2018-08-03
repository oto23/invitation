//
//  FindFriendsCell.swift
//  Invitation
//
//  Created by Macbook pro on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//
import UIKit
protocol FindFriendsCellDelegate: class {
    func didTapFollowButton(_ requesButton: UIButton, on cell: FindFriendsCell)
}
class FindFriendsCell: UITableViewCell {
    weak var delegate: FindFriendsCellDelegate?
    
    
    @IBOutlet weak var requestButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        requestButton.setTitle("Send request", for: .normal)
        requestButton.setTitle("Sent", for: .selected)
    }
    @IBAction func requestButtonTapped(_ sender: UIButton) {
        delegate?.didTapFollowButton(sender, on: self)
    }
}
