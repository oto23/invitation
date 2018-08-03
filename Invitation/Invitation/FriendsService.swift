//
//  FriendsService.swift
//  Invitation
//
//  Created by Macbook pro on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import FirebaseDatabase
//
//
//
//struct FriendsService {
//    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
//        // 1
//        let currentUID = User.current.uid
//        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
//                          "following/\(currentUID)/\(user.uid)" : true]
//        
//        // 2
//        let ref = Database.database().reference()
//        ref.updateChildValues(followData) { (error, _) in
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//            }
//            
//            // 3
//            success(error == nil)
//        }
//    }
//}
