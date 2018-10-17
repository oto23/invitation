//
//  AppDelegate.swift
//  Invitation
//
//  Created by Macbook pro on 7/24/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseMessaging
import FirebaseInstanceID


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        
        FirebaseApp.configure()

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        configureInitialRootViewController(for: window)

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

            if let currentUserUID = User.currentIfLoggedIn?.uid! {

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
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted:\(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
         
        
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: UIApplication.shared.registerForRemoteNotifications)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
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
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
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
