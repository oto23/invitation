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
    var invitedUserUids: [String] = []
    
    enum InvitedUserStatus: Int {
        case awaitingResponse = 0
        case acceptedInvite
        case declinedInvite
    }
    
    var dictValue: [String: Any] {
        let userDict = [
            "uid": author.uid!,
            "username": author.username!
        ]
        
        var dictionaryValue: [String: Any] = [
            "author": userDict,
            "long": long,
            "lat": lat,
            "uid": key
        ]
        
        //map invited users into [Uid: true]
        if invitedUserUids.count > 0 {
            let invitedUsersDict = invitedUserUids.reduce(into: [String: Int]()) { (dict, aUid) in
                dict[aUid] = InvitedUserStatus.awaitingResponse.rawValue
            }
            dictionaryValue["invited_friends"] = invitedUsersDict
        }
        
        return dictionaryValue
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
            let uid = dict["uid"] as? String,
            let long = dict["long"] as? Double,
            let lat = dict["lat"] as? Double
            else { return nil }
        
        
        self.key = uid
        self.author = User(uid: authorUID, username: authorUsername)
        self.long = long
        self.lat = lat
        
        if let invitedUserDict = dict["invited_friends"] as? [String: Any] {
            self.invitedUserUids = Array<String>(invitedUserDict.keys)
        }
    }
}

