//
//  AppDelegate.swift
//  Invitation
//
//  Created by Macbook pro on 7/24/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // FirebaseApp.configure()
        configureInitialRootViewController(for: window)
        
        
        
        
        
        //        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        //
        //
        //        if let initialViewController = storyboard.instantiateInitialViewController() {
        //
        //            window?.rootViewController = initialViewController
        //
        //            window?.makeKeyAndVisible()
        //        }
        
        
        
        
        application.registerForRemoteNotifications()
        //- posts
        //- users
        //- invites
        //-- <user.uid that was invited>
        //--- <entire post>
        
        //Observe for open invites
        let refOfInvites = Database.database().reference().child("invites")
        refOfInvites.observe(.value) { (snapshot) in
            guard let invitedFriends = snapshot.children.allObjects as? [DataSnapshot] else {
                fatalError("snapshot was not a dictionary")
            }
            
            if let currentUserUID = User.currentIfLoggedIn?.uid!{
                
                //check if my uid is in the snapshot
                guard let invitedPostSnapshot = invitedFriends.first(where: { $0.key == currentUserUID }) else {
                    return
                }
                
                guard let postFromSnapshot = Post(snapshot: invitedPostSnapshot) else {
                    fatalError("failed to create post from snapshot")
                }
                
                NotificationCenter.default.post(name: .UserDidRecieveInvite, object: postFromSnapshot)
            }
        }
        ////
        
        Auth.auth().addStateDidChangeListener{(auth,user) in
            if user != nil && user!.isEmailVerified{
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Login", bundle:nil)
                let nextView: SignInViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                self.window?.rootViewController = nextView
            }
            
        }
        
        
        return true
        
        
        
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Add any custom logic here.
        return handled
    }
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
}

extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if let _ = Auth.auth().currentUser,
            let userData = defaults.object(forKey: User.Constants.UserDefaults.currentUser) as? Data,
            let user = try? JSONDecoder().decode(User.self, from: userData) {
            User.setCurrent(user)
            initialViewController = UIStoryboard.initialViewController(for: .main)
        } else {
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    
    static var menuBool = true
    
    
    
    
    
}

