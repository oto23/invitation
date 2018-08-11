//
//  Post.swift
//  Invitation
//
//  Created by Nika Talakhadze on 8/8/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Post {
    var key: String
    var author: User
    var long: Double
    var lat: Double
    
    var dictValue: [String: Any] {
        let userDict = [
            "uid": author.uid!,
            "username": author.username!
        ]
        
        return [
            "author": userDict,
            "long": long,
            "lat": lat
        ]
    }
    
    init(key: String, author: User, long: Double, lat: Double) {
        self.key = key
        self.author = author
        self.long = long
        self.lat = lat
    }
    
    init?(snapshot: DataSnapshot) {
        //        fatalError("not implmeneted, yet")
        guard
            let dict = snapshot.value as? [String : Any],
            let author = dict["author"] as? [String: Any],
            let authorUID = author["uid"] as? String,
            let authorUsername = author["username"] as? String,
            let long = dict["long"] as? Double,
            let lat = dict["lat"] as? Double
            else { return nil }
        
        
        self.key = snapshot.key
        self.author = User(uid: authorUID, username: authorUsername)
        self.long = long
        self.lat = lat
    }
}

