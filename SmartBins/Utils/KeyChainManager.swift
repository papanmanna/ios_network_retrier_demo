//
//  KeyChainManager.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 19/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation
import KeychainSwift

class KeyChainManager {
    
    
    static let ACCESS_TOKEN = "access_token"
    static let REFRESH_TOKEN = "refresh_token"
    static let CRM_ID = "crm_id"
    static let USER_NAME = "user_name"
    
    
    public static func saveTokenResponse(accessToken: String, refreshToken: String) {
        KeychainSwift().set(accessToken, forKey: ACCESS_TOKEN)
        KeychainSwift().set(refreshToken, forKey: REFRESH_TOKEN)
        
    }
    
    public static func saveUserDetails(tokenResponse: LoginResponse) {
        KeychainSwift().set(tokenResponse.crmid!, forKey: CRM_ID)
        KeychainSwift().set(tokenResponse.name!, forKey: USER_NAME)
    }
    
    public static func getAccessToken() -> String? {
        return KeychainSwift().get(ACCESS_TOKEN)
    }
    
    public static func getRefreshToken() -> String? {
        return KeychainSwift().get(REFRESH_TOKEN)
    }
    
    public static func getUserId() -> String? {
        return KeychainSwift().get(CRM_ID)
    }
    
    public static func getUserName() -> String? {
        return KeychainSwift().get(USER_NAME)
    }
    
    
    public static func logout() {
        KeychainSwift().delete(ACCESS_TOKEN)
        KeychainSwift().delete(REFRESH_TOKEN)
        KeychainSwift().delete(CRM_ID)
        KeychainSwift().delete(USER_NAME)        
    }
    
}
