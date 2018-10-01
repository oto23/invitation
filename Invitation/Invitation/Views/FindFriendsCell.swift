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
class FindFriendsCell: FriendTableViewCell {
    
    // MARK: - VARS
    
    weak var delegate: FindFriendsCellDelegate?
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var requestButton: UIButton!
    @IBAction func requestButtonTapped(_ sender: UIButton) {
        delegate?.didTapFollowButton(sender, on: self)
    }
    
    // MARK: - LIFE CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        requestButton.layer.borderColor = UIColor.lightGray.cgColor
        requestButton.layer.borderWidth = 1
        requestButton.layer.cornerRadius = 6
        requestButton.clipsToBounds = true
        
        requestButton.setTitle("Send request", for: .normal)
        requestButton.setTitle("Cancel", for: .selected)
    }
}
