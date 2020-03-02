//
//  Utils.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 29/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation
import GoogleMaps

class Utils {
    
    static func getAddressFromLatLong(lat: Double, lon: Double, completion: @escaping (_ address: String?) -> ())  {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
            if error != nil {
                completion(nil)
                return
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.administrativeArea != nil {
                    addressString = addressString + pm.administrativeArea! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country!
                }
                
                completion(addressString)
                
            } else {
                completion(nil)
            }
        })
    }
}
