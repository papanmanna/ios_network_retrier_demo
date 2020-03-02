//
//  NetworkConfig.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 19/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation

class NetworkManager {
    
    public static var manager : RestManager!
    
    public static func configure() {
        manager = RestManager()
    }
    
}
