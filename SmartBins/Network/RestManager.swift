//
//  NetworkManager.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 17/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation
import Alamofire


class RestManager {
    
    private let sessionManager: SessionManager
    
    
    public init() {
        self.sessionManager = SessionManager()
        sessionManager.adapter = NetworkRequestAdapter()
        sessionManager.retrier = NetworkRequestRetrier()
    }
    
    
    func login(id: String,password: String) -> DataRequest {
        
        let requestParam = [
            "crmid": id,
            "password": password
        ]
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        return Alamofire.request(ApiURl.ApiParameterKey.loginURL, method: .post, parameters: requestParam, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300)
        
    }
    
    
    func changePassword(oldPassword: String, newPassword: String) -> DataRequest {
        
        let requestParam = [
            "old_password": oldPassword,
            "new_password": newPassword,
        ]
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "platform": "mobile"
        ]
        
        return sessionManager.request(ApiURl.ApiParameterKey.changePasswordURL, method: .post, parameters: requestParam, encoding: JSONEncoding.default, headers: headers).debugLog().validate(statusCode: 200..<300)
        
    }
    
    
    func getDeviceList(pageNo: Int, pageSize: Int ) -> DataRequest {
        
        let requestParam = [
            "page_size": pageSize,
            "page_no": pageNo
        ]
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "platform": "mobile"
        ]
        
        return sessionManager.request(ApiURl.ApiParameterKey.getDeviceList, method: .get, parameters: requestParam, encoding: URLEncoding(destination: .queryString), headers: headers).debugLog().validate(statusCode: 200..<300)
    }
    
    
    
    
}
