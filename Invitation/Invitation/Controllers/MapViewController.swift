//
//  Map.swift
//  Invitation
//
//  Created by Nika Talakhadze on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class MapViewController: UIViewController, CLLocationManagerDelegate
{

    // MARK: - VARS

    var post: Post!
    var user: User!
    var invitedFriendsString = [String]()
    let manager = CLLocationManager()

    // MARK: - RETURN VALUES

    // MARK: - METHODS

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let InvitedFriendsViewController = segue.destination as? InvitedFriendsViewController{
            InvitedFriendsViewController.list2 = invitedFriendsString
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(post.lat, post.long)

        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)

        self.map.showsUserLocation = true

    }

    // MARK: - IBACTIONS

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var sendersNameLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!

    @IBAction func goBack(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func joinButtonTapped(_ sender: UIButton) {
        PostService.accept(post: self.post) { (isSuccessful) in
            if isSuccessful {
                self.performSegue(withIdentifier: "toInvitedFriends", sender: nil)
            } else {
                let alertError = UIAlertController(error: nil)
                self.present(alertError, animated: true)
            }
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        PostService.decline(post: self.post) { (isSuccessful) in
            if isSuccessful {
                self.presentingViewController?.dismiss(animated: true)
            } else {
                let alertError = UIAlertController(error: nil)
                self.present(alertError, animated: true)
            }
        }
    }

    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.applyGradient()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        sendersNameLabel.text = post.author.username
        invitedFriendsString = post.invitedUserUids

        //update the invite location title label
        let location = LocationStack()
        location.place(for: (post.long, post.lat)) { (locationTitle) in
            if let title = locationTitle {
                self.keyLabel.text = title
            } else {
                self.keyLabel.text = ""
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //update the UI based off of the infomation from the post var

        //MKAnnotation
        //        map.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
    }
}
