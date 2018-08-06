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
    
    
    
    @IBOutlet weak var requestButton: UIButton!
    
    
    weak var delegate: FindFriendsCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        requestButton.layer.borderColor = UIColor.lightGray.cgColor
        requestButton.layer.borderWidth = 1
        requestButton.layer.cornerRadius = 6
        requestButton.clipsToBounds = true
        
        
        
    }
    @IBAction func requestButtonTapped(_ sender: UIButton) {
        
        requestButton.setTitle("Send request", for: .normal)
        requestButton.setTitle("Sent", for: .selected)
        delegate?.didTapFollowButton(sender, on: self)
        
        
        print("tapped")
    }
}
