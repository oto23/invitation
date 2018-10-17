//
//  StorageService.swift
//  KifuSF
//
//  Created by Alexandru Turcanu on 28/07/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct StorageService {
    static func newUserProfileReference(withUser uid: String) -> StorageReference {
        return Storage.storage().reference().child("profile-images/\(uid)/profile-image.jpg")
    }
    
    public static func uploadImage(
        _ image: UIImage,
        at reference: StorageReference,
        completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.05) else {
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return  completion(nil)
                }
                return completion(url)
            })
        }
    }
}
