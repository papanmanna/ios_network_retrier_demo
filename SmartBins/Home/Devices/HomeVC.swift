//
//  HomeVC.swift
//  Test1
//
//  Created by Geotech Infoservices Private Limited on 15/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import XLPagerTabStrip

class HomeVC: ButtonBarPagerTabStripViewController {
    
    var homeDelegate : HomeControllerDelegate?
    var mapChild : MapVC!
    var deviceChild : DeviceListVC!
    
    
    override func viewDidLoad() {
        self.loadDesign()
        super.viewDidLoad()
        edgesForExtendedLayout = []
        configureNavigationBar()
        //disable left, right swipe
        containerView.isScrollEnabled = false
        
        getDeviceList(pageNo: 1, pageSize: 10, isShowLoader: true)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        mapChild = UIStoryboard(name: "HomeSB", bundle: nil).instantiateViewController(withIdentifier: "MapVC") as? MapVC
        deviceChild = UIStoryboard(name: "HomeSB", bundle: nil).instantiateViewController(withIdentifier: "DeviceListVC") as? DeviceListVC
        return [mapChild, deviceChild]
    }
    
    @objc func handleMenuTogle() {
        homeDelegate?.handleMenutoggle()
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 221/255, green: 0, blue: 51/255,alpha: 1)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "devices".localized().localizedUppercase
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 20)!]
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal) , style: .plain, target: self, action: #selector(handleMenuTogle))
    }
    
    func loadDesign() {
        
        settings.style.buttonBarBackgroundColor = UIColor(red: 221/255, green: 0, blue: 51/255,alpha: 1)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 221/255, green: 0, blue: 51/255,alpha: 1)
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont =  UIFont(name: "Roboto-Medium", size: 16)!
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth  = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 60
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(red: 1, green: 1, blue: 1,alpha: 0.75)
            newCell?.label.textColor = .white
        }
    }
    
    func getDeviceList(pageNo: Int, pageSize: Int, isShowLoader: Bool) {
        
        if isShowLoader {
            self.showSpinner(onView: self.view)
        }
        
        NetworkManager.manager.getDeviceList(pageNo: pageNo, pageSize: pageSize)
            .responseJSON { (response) in
                if isShowLoader {
                    self.removeSpinner()
                }
                switch response.result {
                    case .success:
                        
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(deviceListResponse.self, from: data) else {
                            print("Error")
                            return
                        }
                        
                        //update map
                        self.mapChild.deviceList.append(contentsOf: (getResponse.result?.devices)!)
                        if self.mapChild.mapView != nil {
                            self.mapChild.loadMarker()
                        }
                        
                        //update device
                        self.deviceChild.deviceList.append(contentsOf: (getResponse.result?.devices)!)
                        if self.deviceChild.deviceListTableView != nil {
                            self.deviceChild.deviceListTableView.reloadData()
                        }
                        
                        // Pagination...
                        if (getResponse.result?.count)! - (pageSize * pageNo) >= 0 {
                            self.getDeviceList(pageNo: pageNo + 1, pageSize: pageSize, isShowLoader: false)
                        }
                    case .failure:
                        if response.response?.statusCode == 401 {
                            self.logoutFromView()
                            return
                        }
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(OnlyMessageResponse.self, from: data) else {
                            return
                        }
                        self.showAlertOnlyDismiss(title: "error".localized(), message: getResponse.message!)
                }
        }
    }
    
    
}
