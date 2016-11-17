//
//  Location.swift
//  PStat
//
//  Created by media-pt on 08.11.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    private static var manager: OneShotLocationManager?
    
    static func registerUserLocation(completionHandler:((_ latitude: Double, _ longitude: Double) -> Void)!) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("Location Manager: No access")
                completionHandler(0.0, 0.0)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Location Manager: Access")
                manager = OneShotLocationManager()
                manager!.fetchWithCompletion {location, error in
                    
                    // fetch location or an error
                    if let loc = location {
                        print("Location Manager: \(loc.description)")
                        let latitude: Double = loc.coordinate.latitude
                        let longitude: Double = loc.coordinate.longitude
                        completionHandler(latitude, longitude)
                    } else if let err = error {
                        print("Location Manager: \(err.localizedDescription)")
                        completionHandler(0.0, 0.0)
                    }
                    
                    // destroy the object immediately to save memory
                    self.manager = nil
                }
            }
        } else {
            print("Location services are not enabled")
            completionHandler(0.0, 0.0)
        }
    }
}
