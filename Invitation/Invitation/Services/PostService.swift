//
//  PostService.swift
//  Invitation
//
//  Created by Nika Talakhadze on 8/8/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import MapKit

struct PostService {
    
    static func create(name: String, long: Double, lat: Double, invitedUsers: [User], completion: @escaping (Post?) -> ()) {
        
        
        let author = User.current
        
        //        guard,
        //            let long = currentLocation.coordinate.longitude,
        //            let lat = currentLocation.coordinate.latitude else {
        //                completion(false)
        //                return
        //        }
        
        //get reference to firebase DB
        let ref = Database.database().reference().child("open_invites").childByAutoId()
        
        
        //create a Post object with the name, long and lat
        var newPost = Post(key: ref.key!, author: author, long: long, lat: lat)
        
        //add invited friends uid to newPost
        let inviteduserUids = invitedUsers.map { aUser -> String in
            return aUser.uid!
        }
        newPost.invitedUserUids = inviteduserUids
        
        //get dictionary from post.dictValue
        let postDict = newPost.dictValue
        
        //upload the post dictionary to the reference
        ref.setValue(postDict) { (error, _) in
            
            //if no errors come when uploading, then
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            let dg = DispatchGroup()
            
            //loop through each invitedUser and send an invite post
            for aFriend in invitedUsers {
                dg.enter()
                self.invite(friend: aFriend, to: newPost) { (success) in
                    dg.leave()
                    
                    guard success == true else {
                        return print("there was an error uploading the invite")
                    }
                }
            }
            
            dg.notify(queue: DispatchQueue.main, execute: {
                completion(newPost)
            })
        }
    }
    
    static func invite(friend: User, to post: Post, completion: @escaping (Bool) -> ()) {
        let ref = Database.database().reference().child("invites").child(friend.uid!)
        
        ref.setValue(post.dictValue) { (error, _) in
            
            
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            completion(true)
        }
    }
    
    private static var friendsStatusesRef: UInt?
    
    static func observeFriendStatuses(for post: Post, completion: @escaping ([String: Post.InvitedUserStatus]?) -> Void) {
        let postRef = Database.database().reference()
            .child("open_invites")
                .child(post.key)
                    .child("invited_friends")
        self.friendsStatusesRef = postRef.observe(.value) { (snapshot) in
            guard let userUids = snapshot.children.allObjects as? [DataSnapshot] else {
                assertionFailure("there was an error fetching the friend statuses")
                
                return completion(nil)
            }
            
            let userUidStatuses = userUids.reduce(into: [String: Post.InvitedUserStatus](), { (sum, aSnapshot) in
                sum[aSnapshot.key] = Post.InvitedUserStatus(rawValue: aSnapshot.value as! Int)!
            })
            completion(userUidStatuses)
        }
    }
    
    static func unobserveFriendsStatuses(for post: Post) {
        if let ref = self.friendsStatusesRef {
            let postRef = Database.database().reference()
                .child("open_invites")
                    .child(post.key)
                        .child("invited_friends")
            postRef.removeObserver(withHandle: ref)
        }
    }
    
    static func accept(post: Post, completion: @escaping (Bool) -> Void) {
        let currentUserUid = User.current.uid!
        
        let postRef = Database.database().reference()
            .child("open_invites")
                .child(post.key)
                    .child("invited_friends")
                        .child(currentUserUid)
        postRef.setValue(Post.InvitedUserStatus.acceptedInvite.rawValue) { (error, _) in
            if let err = error {
                assertionFailure("there was an error accepting the invite: \(err.localizedDescription)")
                
                return completion(false)
            }
            
            self.removeInvite(completion: { (isSuccessful) in
                completion(isSuccessful)
            })
        }
    }
    
    static func decline(post: Post, completion: @escaping (Bool) -> Void) {
        let currentUserUid = User.current.uid!
        
        let postRef = Database.database().reference()
            .child("open_invites")
            .child(post.key)
            .child("invited_friends")
            .child(currentUserUid)
        postRef.setValue(Post.InvitedUserStatus.declinedInvite.rawValue) { (error, _) in
            if let err = error {
                assertionFailure("there was an error declining the invite: \(err.localizedDescription)")
                
                return completion(false)
            }
            
            self.removeInvite(completion: { (isSuccessful) in
                completion(isSuccessful)
            })
        }
    }
    
    
    static let ref = Database.database().reference()
    
    
    private static func removeInvite(completion: @escaping (Bool) -> Void) {
        let currentUserUid = User.current.uid!
        
        let ref = self.ref.child("invites").child(currentUserUid)
        ref.removeValue { error, _ in
            if let err = error {
                assertionFailure("there was an error removing the invite: \(err.localizedDescription)")
                
                return completion(false)
            }
            
            completion(true)
        }
    }
    
//    static func getInvitedFriends(){
//         
//    }
    
}


