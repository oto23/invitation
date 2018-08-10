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
import MapKit


class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

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

//
//        let storyboard = UIStoryboard(name: "Users", bundle: Bundle.main)
//        let mapView = storyboard.instantiateViewController(withIdentifier:"UsersTableViewController") as! UsersTableViewController
//        self.present(mapView, animated: true, completion: nil)


        //create a post from the information, like invited friends and location
//        PostService.create(name: <#T##String#>, long: <#T##Double#>, lat: <#T##Double#>, invitedUsers: <#T##[User]#>, completion: <#T##(Bool) -> ()#>)


    }
    var listOfFollowers = [User]()
    var listOfFollowees = [User]()
    var listOfFriends = [User]()
    var listOfFriendsString = [String]()
    
    var selectedArray = [String]()
    var tempList = [String]()
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    



    @IBOutlet weak var friendsTableView: UITableView!





    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = inviteListener
        
        menuVc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
//        friendsTableView.allowsMultipleSelection = true

        fetchFollowers { success in
            self.fetchFollowees { success in
                self.findFriends()
            }
        }









        friendsTableView.delegate = self
        friendsTableView.dataSource = self
//        setUpSearchBar()
        friendsTableView.allowsMultipleSelection = true
        setUpSearchBar()
        
    }
    
    private func setUpSearchBar(){
        search.delegate = self
        
        
    }

    func fetchFollowees(completion: @escaping (Bool) -> ()) {
        guard let currentUID = User.current.uid else {return}
        print(currentUID)

        ref = Database.database().reference().child("following").child(currentUID)
        ref.observeSingleEvent(of: .value) { (snapshot) in

            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                return assertionFailure("Failed to get following")
            }

            for snap in snapshots {
                //                guard let user = User(snapshot: snap) else {
                //                    return assertionFailure("Failed to create user")
                //                }

                let userId = snap.key
                print(userId)

                let userRef = Database.database().reference().child("users").child(userId)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in

                    guard let user = User(snapshot: snapshot) else {
                        fatalError("failed to create a user from the snapshot")
                    }
                    //                    guard let dict = snapshot.value as? [String: Any],
                    //                          let userDetailsDict = dict["userDetails"] as? [String: Any],
                    //                          let username = userDetailsDict["Username"] as? String else {
                    //                            return assertionFailure("Failed to get username")
                    //                    }

                    // Append username in listOfFollowees array
                    //                    self.listOfFollowees.append(username)
//                    guard let username = user?.username else { return }

                    self.listOfFollowees.append(user)

                    completion(true)

                    print("Followees: \(self.listOfFollowees)")

                })

            }
        }

    }

    func fetchFollowers(completion: @escaping (Bool) -> ()) {
        guard let currentUID = User.current.uid else {return}
        ref2 = Database.database().reference().child("followers").child(currentUID)
        ref2.observeSingleEvent(of: .value) { (snapshot) in

            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                return assertionFailure("Failed to get following")
            }


            for snap in snapshots {

                let userId = snap.key
                print(userId)

                let userRef = Database.database().reference().child("users").child(userId)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in

                    guard let user = User(snapshot: snapshot) else {
                        fatalError("failed to create a user from the snapshot")
                    }

//                    guard let username = user else { return }

                    self.listOfFollowers.append(user)


                    completion(true)
                    print("Followers: \(self.listOfFollowers)")


                })

            }
        }

    }

    func findFriends() {
        let followersSet = Set<User>(self.listOfFollowers)
        let followingSet = Set<User>(self.listOfFollowees)
        self.listOfFriends = Array<User>(followersSet.intersection(followingSet))
        

//        for user in listOfFollowees{
////            print("this is user:\(user)")
//            for user1 in listOfFollowers{
////                print("this is user:\(user1)")
//                if user == user1{
//                    listOfFriends.append(user1)
//                    print("friends")
//                    print(listOfFriends)
//
//                }
//            }
//        }
        self.friendsTableView.reloadData()
    }


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == friendsTableView{
            return listOfFriends.count
        }else{
            return tempList.count
        }
        
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)// as! UITableViewCell
        
       let user = listOfFriends[indexPath.row]
//        let user2 = tempList[indexPath.row]
        listOfFriendsString.append(user.username!)
        if tableView == friendsTableView{
            cell.textLabel?.text = listOfFriendsString[indexPath.row]
        }else{
            cell.textLabel?.text = tempList[indexPath.row]
        }
        cell.textLabel?.textColor = #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.02352941176, alpha: 1)
        cell.backgroundColor = UIColor.darkGray

        return (cell)

    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)
        selectedArray.append((currentCell?.textLabel?.text)!)
        print(currentCell?.textLabel!.text)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        tempList = listOfFriendsString.filter({ (item: String) -> Bool in
            
            
            if item.contains(searchBar.text!.lowercased()){
                print(searchBar.text)
                return true
            } else {
                
                return false
            }
        })

        
    friendsTableView.reloadData()
    }
    


    var menuVc : MenuViewController!

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        print(listOfFriends[indexPath.row])
//
//        // 1. preparing the data to send
////        reciever.append(listOfFriends[indexPath.row])
//
//        // 2. change the ui of the cell
//        let cell = self.friendsTableView.cellForRow(at: indexPath)
//        cell?.accessoryType = .checkmark
//    }


    
    
        // Do any additional setup after loading the view, typically from a nib.


    




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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let CheckListViewController = segue.destination as? CheckListViewController{
            CheckListViewController.listOfSelectedFriends = selectedArray
            
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
