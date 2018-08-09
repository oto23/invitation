//
//  ViewController.swift
//  Invitation
//
//  Created by Macbook pro on 7/24/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //COPY ME
    lazy var inviteListener = InviteListener(delegate: self)
    
//    continue
//
//    unowned
//
//    private
//
//    public
//
//    open
//
//    final
//
//    static
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBAction func inviteButton(_ sender: Any) {
        
        //create a post from the information, like invited friends and location
//        PostService.create(name: <#T##String#>, long: <#T##Double#>, lat: <#T##Double#>, invitedUsers: <#T##[User]#>, completion: <#T##(Bool) -> ()#>)
        
    }
    
    let listOfFriends = ["Sam", "Niko", "Oto"]
    
    var reciever = [String]()
    
    @IBOutlet weak var friendsTableView: UITableView!
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (listOfFriends.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = "Name and last name"
        cell.textLabel?.textColor = #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.02352941176, alpha: 1)
        cell.backgroundColor = UIColor.darkGray
        return (cell)
        
    }
    
    var menuVc : MenuViewController!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(listOfFriends[indexPath.row])
        
        // 1. preparing the data to send
        reciever.append(listOfFriends[indexPath.row])
        
        // 2. change the ui of the cell
        let cell = self.friendsTableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _ = inviteListener
        
         menuVc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
        friendsTableView.allowsMultipleSelection = true
    }

    
    
    
    @IBAction func logoutButton(_ sender: Any)
    {
        do{
            
            Analytics.logEvent("signout", parameters: nil)
            for userInfo in (Auth.auth().currentUser?.providerData)!
            {
                if userInfo.providerID == "facebook.com"
                {
                    FBSDKLoginManager().logOut()
                    break
                }
            }
            
            
            
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let signInPage = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let  appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
            
            
            
            
        }catch{
            self.showMessage(messageToDisplay: "Could not sign out at this time")
            
        }
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
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer)
    {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            print("Right Swipe")
            openMenu()
            
        case UISwipeGestureRecognizerDirection.left:
            print("Left Swipe")
            swipeClose()
            
        default:
            break
        }
    }
    
    
    @IBAction func menuAction(_ sender: Any) {
        
        if AppDelegate.menuBool {
            openMenu ()
        } else {
             closeMenu ()
        }
        
        
    }
    
    func swipeClose() {
        
        if AppDelegate.menuBool {
           // openMenu ()
        } else {
            closeMenu ()
        }
    }
    
    
    func openMenu () {
        
        UIView.animate(withDuration: 0.3) { ()->Void in
            
            self.menuVc.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.menuVc.view.backgroundColor = UIColor.black
            self.addChildViewController(self.menuVc)
            self.view.addSubview(self.menuVc.view)
            AppDelegate.menuBool = false
        }
        
        
    }
    
    func closeMenu ()
    
    {
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.menuVc.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (finished) in
        
        self.menuVc.view.removeFromSuperview()
        }
        
        AppDelegate.menuBool = true
    }
    
    
}

//copy the inviteListener var and this extension
extension NewViewController: InviteListenerDelegate {
    func inviteListner(_ listener: InviteListener, userDidRecieveInviteFor post: Post) {
        let joinStoryboard = UIStoryboard(name: "MapLocation", bundle: nil)
        guard
            let viewController = joinStoryboard.instantiateInitialViewController(),
            let mapViewController = viewController as? MapViewController
            else {
                fatalError("storybaord not set up correctly with view controlle classes")
        }
        
        mapViewController.post = post
        self.present(mapViewController, animated: true)
    }
}
            

        
        

    
    
    


