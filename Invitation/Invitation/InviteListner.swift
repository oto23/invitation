//
//  InviteListner.swift
//  Invitation
//
//  Created by Nika Talakhadze on 8/8/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

protocol InviteListenerDelegate: class {
    func inviteListner(_ listener: InviteListener, userDidRecieveInviteFor post: Post)
}

class InviteListener: NSObject {
    
    weak var delegate: InviteListenerDelegate?
    
    init(delegate: InviteListenerDelegate) {
        self.delegate = delegate
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(InviteListener.recieveInvite(_:)), name: .UserDidRecieveInvite, object: nil)
    }
    
    @objc private func recieveInvite(_ notification: Notification) {
        guard let postFromNotifcation = notification.object as? Post else {
            fatalError("notifaciton did not send a post object")
        }
        
        delegate?.inviteListner(self, userDidRecieveInviteFor: postFromNotifcation)
    }
}

extension NSNotification.Name {
    static let UserDidRecieveInvite = NSNotification.Name("UserDidRecieveInvite")
}
