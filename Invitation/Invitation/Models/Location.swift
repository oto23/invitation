//
//  Location.swift
//  Invitation
//
//  Created by Erick Sanchez on 9/28/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationStack {
    func place(for coordinates: (long: Double, lat: Double), result: @escaping (String?) -> Void) {
        let coder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.lat, longitude: coordinates.long)
        coder.reverseGeocodeLocation(location) { (placemarkers, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                
                return result(nil)
            }
            
            guard let placemarker = placemarkers?.first else {
                return result(nil)
            }
            
            result(placemarker.name)
        }
    }
}
