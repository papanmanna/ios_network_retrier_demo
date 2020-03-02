//
//  AppDelegate.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 17/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        NetworkManager.configure()
        
        if let _ = KeyChainManager.getUserId(), let _ =  KeyChainManager.getAccessToken() {
            self.window?.rootViewController = ContainerVC()
            self.window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "LoginSB", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        GMSServices.provideAPIKey("AIzaSyCdNQWWclhzN3uv9Yd0PhGt4E5XbSky2ZY")
        return true
    }
    
    
}

