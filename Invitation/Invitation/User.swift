//
//  User.swift
//  Invitation
//
//  Created by Macbook pro on 7/31/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase

struct User {
    var uid: String?
    var firstName: String?
    var lastName: String?
    var username: String?
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        return currentUser
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let userDetails = dict["userDetails"] as? [String : Any],
        let username = userDetails["Username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
    }
    
//    init(authData:Firebase.User){
//        uid = authData.uid
//    }
    init(uid: String, username:String){
        self.uid = uid
        self.username = username
    }
}
