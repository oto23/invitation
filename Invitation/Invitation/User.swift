//
//  User.swift
//  Invitation
//
//  Created by Macbook pro on 7/31/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase

class User: Codable {
    var uid: String?
    var firstName: String?
    var lastName: String?
    var username: String?
    var isFollowed = false
    
    

    
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
    struct Constants {
        struct UserDefaults {
        static let currentUser = "currentUser"
        }
        
    }
    private static var _current: User?
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        return currentUser
    }
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = true) {
        if writeToUserDefaults {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            }
        }
        
        _current = user
    }
        


}

