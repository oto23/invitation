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
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var map: MKMapView!
    
    
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    

    @IBOutlet weak var joinButtonOutlet: UIButton!
    
    @IBAction func JoinButton(_ sender: UIButton) {
        
        PostService.invitationAccepted(friend: User.current) { (success) in
            if success{
                self.joinButtonOutlet.isEnabled = false
                
            }
        }
        
    }
    
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBAction func cancelButton(_ sender: UIButton) {
        PostService.invitationDenied(friend: User.current) { (success) in
            if success{
                self.cancelButtonOutlet.isEnabled = false
                
            }
        }
    }
    
    var post: Post!
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(post.lat, post.long)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        NameLabel.text = post.author.username
        
        
    }
    
    @IBOutlet weak var NameLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //update the UI based off of the infomation from the post var
        
        //MKAnnotation
//        map.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
    }
    
    
}









