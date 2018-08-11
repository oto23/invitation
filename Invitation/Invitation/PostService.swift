//
//  PostService.swift
//  Invitation
//
//  Created by Nika Talakhadze on 8/8/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

struct PostService {
    static func create(name: String, long: Double, lat: Double, invitedUsers: [User], completion: @escaping (Bool) -> ()) {


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
        let newPost = Post(key: ref.key, author: author, long: long, lat: lat)


        //get dictionary from post.dictValue
        var postDict = newPost.dictValue

        let invitedUsersDict = invitedUsers.reduce([String: Int]()) { (dict, aUser) -> [String: Int] in
            var dictCopy = dict
            dictCopy[aUser.uid!] = 0

            return dictCopy
        }

        postDict["invited_friends"] = invitedUsersDict

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
                completion(true)
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
}

    static func invitationAccepted(friend: User, completion: @escaping (Bool) -> ()){

//        var post: Post!
//        let ref = Database.database().reference().child("open_invites").child("invited_friends")
//
//        ref.setValue(1) { (error, _) in
//
//
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//            }

            completion(true)
//        }
    }
    static func invitationDenied(friend: User, completion: @escaping (Bool) -> ()){
//        let ref = Database.database().reference().child("open_invites").child("friend_uid").childByAutoId()
//
//        ref.setValue(2) { (error, _) in
//
//
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//            }
//
            completion(true)
//        }
    }

}
