//
//  LoginViewController.swift
//  Invitation
//
//  Created by Macbook pro on 7/26/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseUI




class SignInViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {


    @IBOutlet weak var userEmailTextField: UITextField!

    @IBOutlet weak var userPasswordTextField: UITextField!

    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var loginWithFbButton: FBSDKLoginButton!



    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: nick-use this for the gradient
        self.view.applyGradient()

        loginWithFbButton.delegate = self
        loginWithFbButton.readPermissions = ["email"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true)
        self.view.endEditing(true)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let userEmail = userEmailTextField.text, !userEmail.isEmpty else{
            self.showMessage(messageToDisplay: "Email is required")
            return

        }

        guard let userPassword = userPasswordTextField.text, !userPassword.isEmpty else{
            self.showMessage(messageToDisplay: "Password is required")
            return
        }


        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showMessage(messageToDisplay: error.localizedDescription)
                return
            }

            guard let user = result?.user else {
                fatalError("no user")
            }


//            if user.isEmailVerified
//            {
//                self.needToVerifyEmail()
//                return
//            }

            //TODO: erick-uncomment
            //               self.storeTokens()
            //                if !(user?.isEmailVerified)!
            //                {
            //                    self.needToVerifyEmail()
            //                    return
            //                }
            //
            UserService.show(forUID: user.uid) { (user) in
                if let user = user {
                    // handle existing user
                    User.setCurrent(user, writeToUserDefaults: true)

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let displayFriendList = storyboard.instantiateInitialViewController()
                    self.present(displayFriendList!, animated: true, completion: nil)
                } else {
                    //no user found
                }
            }
        }
    }

    public func needToVerifyEmail(){
        let alertController = UIAlertController(title: "Alert Title", message: "Email adress has not been verified", preferredStyle: .alert)



        let resendEmailAction = UIAlertAction(title: "Resend me email", style: .default) {( action: UIAlertAction!) in
            print("resendEmailAction button tapped");

            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                if error == nil
                {
                    print("Email verification reques has been send")
                    try! Auth.auth().signOut()

                }else{
                    self.showMessage(messageToDisplay: "Could not send email verification request.\(String(describing:error?.localizedDescription))")
                    try! Auth.auth().signOut()
                }

            })

        }
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        { (action: UIAlertAction!) in

            print("Close button tapped")
            try! Auth.auth().signOut()
        }

        alertController.addAction(resendEmailAction)
        alertController.addAction(closeAction)

        self.present(alertController,animated: true, completion: nil)

    }


    public func showMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        { (action: UIAlertAction!) in

            print("OK button tapped")
        }
        alertController.addAction(OKAction)
        self.present(alertController,animated: true, completion: nil)
    }




    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){

        if let error = error{
            print("Error took place\(error.localizedDescription)")
            return

        }
        print("success")
        if FBSDKAccessToken.current() == nil{
            return
        }

        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

        Auth.auth().signInAndRetrieveData(with: credential){ (result, error)  in


            if let error = error {
                print("Could not sign in with Facebook because of: \(error.localizedDescription)")
                self.showMessage(messageToDisplay: error.localizedDescription)
                FBSDKLoginManager().logOut()
                return
            }




            guard let user = result?.user else {
                fatalError("no user")

            }
            var userDetails: [String:String] = [:]
            if let userFullName = user.displayName{
                let userNameDetails = userFullName.components(separatedBy: .whitespaces)
                if userNameDetails.count >= 2{
                    userDetails["FirstName"] = userNameDetails[0]
                    userDetails["LastName"] = userNameDetails[1]
                    userDetails["Username"] = userNameDetails[0]
                    userDetails["ImageUrl"] = user.photoURL?.absoluteString
                }
            }
            var databaseReference: DatabaseReference!
            databaseReference = Database.database().reference()

            databaseReference.child("users").child(user.uid).setValue(["userDetails": userDetails])

            UserService.show(forUID: user.uid) { (user) in
                if let user = user {
                    // handle existing user
                    User.setCurrent(user, writeToUserDefaults: true)


                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let displayFriendlist = storyboard.instantiateInitialViewController() as! UINavigationController
                    self.present(displayFriendlist, animated: true, completion: nil)

                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = displayFriendlist
                    //                    self.performSegue(withIdentifier: "toMainStoryboard", sender: self)
                } else {
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let chooseUsername = storyboard.instantiateViewController(withIdentifier:"UsernameViewController") as! UsernameViewController
                    self.present(chooseUsername, animated: true, completion: nil)

                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = chooseUsername
                }
            }

        }


    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User signed out")
    }




}

extension SignInViewController: FUIAuthDelegate {
    private func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }

        guard let user = user
            else { return }

        UserService.show(forUID: user.uid!) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)

            }
        }
    }
}
