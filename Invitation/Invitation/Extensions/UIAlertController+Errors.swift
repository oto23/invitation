//
//  UIAlertController+Errors.swift
//  Invitation
//
//  Created by Erick Sanchez on 9/27/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit.UIAlertController

extension UIAlertController {
    convenience init(error message: String?) {
        let alertMessage: String
        if let message = message {
            alertMessage = "Something went wrong: \(message)"
        } else {
            alertMessage = "Something went wrong."
        }
        self.init(title: "Error", message: alertMessage, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(
            title: "Dismiss", style: .default)
        self.addAction(dismissAction)
    }
}
