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
    
    init?(snapshot: DataSnapshot) {
        fatalError("not implmeneted, yet")
    }
}

