//
//  StorageRefence.swift
//  KifuSF
//
//  Created by Alexandru Turcanu on 28/07/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    static func newDonationImageReference(with uid: String) -> StorageReference {
        return Storage.storage().reference().child("profile-images/\(uid)/.jpg")
    }
}
