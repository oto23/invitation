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
        
        //create a Post object with the name, long and lat
        
        //get dictionary from post.dictValue
        
        //get reference to firebase DB
        
        //upload the post dictionary to the reference
        
            //if no errors come when uploading, then
        
            //loop through each invitedUser and send an invite post
//            for aFriend in invitedUsers {
//                invite(friend: aFriend) { (success) in
//                    <#code#>
//                }
//                
//            }
    }
    
    static func invite(friend: User, completion: @escaping (Bool) -> ()) {
        
    }
}
