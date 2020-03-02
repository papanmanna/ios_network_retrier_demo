//
//  ApiURL.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 17/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation


struct ApiURl {
    
    struct BaseURL {
        static let baseURL = "http://192.168.230.230:4000/v1/"
    }
    
    struct ApiParameterKey {
        static let loginURL = BaseURL.baseURL + "customer/login"
        static let refreshTokenURL = BaseURL.baseURL + "refresh_token"
        static let changePasswordURL = BaseURL.baseURL + "customer/change_password"
        static let getDeviceList = BaseURL.baseURL + "customer/devices"
    }
    
    
}
