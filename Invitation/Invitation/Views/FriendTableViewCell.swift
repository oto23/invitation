//
//  FriendTableViewCell.swift
//  Invitation
//
//  Created by Erick Sanchez on 9/29/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Kingfisher

class FriendTableViewCell: UITableViewCell {

    // MARK: - VARS
    
    static let identifier = "friend cell"
    
    static var cellNib: UINib {
        return UINib(nibName: "FriendTableViewCell", bundle: nil)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func configure(image imageUrl: URL?) {
        if let url = imageUrl {
            imageViewProfile.kf.setImage(with: url)
        } else {
            imageViewProfile.image = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageViewProfile.layer.cornerRadius = imageViewProfile.bounds.width / 2.0
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    
    // MARK: - LIFE CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelUsername.textColor = #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.02352941176, alpha: 1)
        self.backgroundColor = UIColor.darkGray
    }
    
}
