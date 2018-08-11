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
struct FriendsService {
    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // 1
        guard let currentUID = User.current.uid, let otherUserID = user.uid else {
            success(false)
            return
        }
        let followData = ["followers/\(otherUserID)/\(currentUID)" : true,
                          "following/\(currentUID)/\(otherUserID)" : true]
        
        // 2
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // 3
            success(error == nil)
        }
    }
    private static func unfollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        guard let currentUID = User.current.uid, let otherUserID = user.uid else {
            success(false)
            return
        }
        // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
        // http://stackoverflow.com/questions/38462074/using-updatechildvalues-to-delete-from-firebase
        let followData = ["followers/\(otherUserID)/\(currentUID)" : NSNull(),
                          "following/\(currentUID)/\(otherUserID)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            success(error == nil)
        }
    }
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    static func isUserFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let currentUID = User.current.uid else { return }
        let ref = Database.database().reference().child("followers").child(user.uid!)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}
