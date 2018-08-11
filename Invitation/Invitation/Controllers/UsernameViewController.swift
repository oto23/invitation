//
//  UsernameViewController.swift
//  Invitation
//
//  Created by Macbook pro on 8/9/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class UsernameViewController: UIViewController {
    
    
    
    @IBOutlet weak var FBloginUsername: UITextField!
    
    @IBOutlet weak var FBloginRegisterButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     Get the new view controller using segue.destinationViewController.
     Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func FBloginRegisterButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = FBloginUsername.text,
            !username.isEmpty else { return }
        
        // 2
        let userAttrs = ["Username": username]
        
        // 3
        let ref = Database.database().reference().child("users").child(firUser.uid).child("userDetails")
        
        // 4
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            // 5
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                
                // handle newly created user here
            })
        }
    }
}
