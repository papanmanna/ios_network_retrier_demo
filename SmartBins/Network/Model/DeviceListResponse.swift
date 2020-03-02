//
//  DeviceListResponse.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 28/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation

struct deviceListResponse : Codable {
    
    let status: Bool?
    let result: Result?
    
}

struct Result : Codable {
    
    let count: Int?
    let devices: [Device]?
    
}

struct Device : Codable {
    
    let device_id: String?
    let latitude: Double?
    let longitude: Double?
    let bin_type: String?
    let depth: Int?
    let battery_status: Bool?
    let fill_percentage: Double?
    
}

