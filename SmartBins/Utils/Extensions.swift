//
//  Extensions.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 20/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


var vSpinner : UIView?

extension UIViewController {
    
    func showAlertOnlyDismiss(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "dismiss".localized(), style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertRetryDismiss(title: String, message: String, handler: DeviceListVC) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "retry".localized(), style: .default, handler: { action in
            //MARK:
        }))
        alertController.addAction(UIAlertAction(title: "dismiss".localized(), style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.color = UIColor(red: 221/255, green: 0, blue: 51/255,alpha: 1)
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        vSpinner?.removeFromSuperview()
        vSpinner?.willMove(toSuperview: nil)
        vSpinner = nil
    }
    
    func logoutFromView() {
        KeyChainManager.logout()
        let storyboard = UIStoryboard(name: "LoginSB", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    
}
extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        #endif
        return self
    }
}

