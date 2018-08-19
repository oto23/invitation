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

class MapViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var map: MKMapView!
    
    
    @IBOutlet weak var sendersNameLabel: UILabel!
    
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    var post: Post!
    var user: User!
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
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
        sendersNameLabel.text = post.author.username
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //update the UI based off of the infomation from the post var
        
        //MKAnnotation
        //        map.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        
        guard let uid = User.current.uid else {return}
        PostService.remove(child: uid)
        
        
        
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let initVC = storyboard1.instantiateViewController(withIdentifier: "CheckListViewController") as! CheckListViewController
        self.present(initVC, animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        guard let uid = User.current.uid else {return}
        PostService.remove(child: uid)
        
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let initVC = storyboard1.instantiateViewController(withIdentifier: "NewViewController") as! NewViewController     
        self.present(initVC, animated: true)
        
    }
}









