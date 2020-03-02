//
//  LoginResponse.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 19/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation

struct LoginResponse : Codable {
  
    let status: Bool?
    let token_type: String?
    let access_token: String?
    let refresh_token: String?
    let expires_in: Int?
    let crmid: String?
    let name: String?
    
}
