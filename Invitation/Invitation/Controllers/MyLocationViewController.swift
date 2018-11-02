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

class MyLocationViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var map: MKMapView!
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = UIStoryboard(name: "Main", bundle: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    var post: Post!
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //update the UI based off of the infomation from the post var
        
        //MKAnnotation
        //        map.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
    }
    
    
    
}
