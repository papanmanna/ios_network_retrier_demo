//
//  NetworkRequestAdapter.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 19/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation
import Alamofire


class NetworkRequestAdapter : RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
           var urlRequest = urlRequest
           if urlRequest.value(forHTTPHeaderField: "Authorization") == nil {
            let accessToken = KeyChainManager.getAccessToken()
            urlRequest.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")
               return urlRequest
           }
           return urlRequest
       }
}
