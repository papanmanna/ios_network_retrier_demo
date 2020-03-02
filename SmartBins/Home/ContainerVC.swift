//
//  ContainerVC.swift
//
//  Created by GeoTech Infoservices Private Limited on 15/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {
    
    var menuController : MenuVC!
    var centerController : UIViewController!
    var isExpanded = false
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHome(storyboard: "HomeSB", identifier: "HomeVC")
    }
    
    func configureMenuVC() {
        if menuController == nil {
            let storyboard = UIStoryboard(name: "HomeSB", bundle: nil)
            menuController = storyboard.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC
            menuController.delegate = self
            menuController.homeDelegate = self
            
        }
    }
    
    func showMenuVC(shouldExpand : Bool) {
        if shouldExpand {
            //show menu
            self.view.addSubview(self.menuController.view)
            self.view.layoutIfNeeded()
            
        } else {
            //hide menu
            self.menuController.view.removeFromSuperview()
            
        }
    }
}

extension ContainerVC: HomeControllerDelegate, ItemMenuDelegate {
    
    func configureHome(storyboard: String, identifier: String) {
        if self.centerController != nil {
            self.centerController.view.removeFromSuperview()
            self.menuController.view.removeFromSuperview()
        }
        self.isExpanded = false
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch identifier {
            case "HomeVC":
                let homeController = storyboard.instantiateViewController(withIdentifier: identifier) as! HomeVC
                homeController.homeDelegate = self
                self.centerController = UINavigationController(rootViewController: homeController)
                self.view.addSubview(self.centerController.view)
                self.addChild(self.centerController)
                self.centerController.didMove(toParent: self)
            
            case "ChangePasswordVC":
                let homeController = storyboard.instantiateViewController(withIdentifier: identifier) as! ChangePasswordVC
                homeController.delegate = self
                self.centerController = UINavigationController(rootViewController: homeController)
                self.view.addSubview(self.centerController.view)
                self.addChild(self.centerController)
                self.centerController.didMove(toParent: self)
            default:
                ()
        }
    }
    func handleMenutoggle() {
        if !isExpanded {
            configureMenuVC()
        }
        isExpanded = !isExpanded
        showMenuVC(shouldExpand: isExpanded)
    }
    
    
}
