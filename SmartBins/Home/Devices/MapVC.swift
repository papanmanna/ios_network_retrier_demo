//
//  MapVC.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 23/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleMaps

class MapVC: UIViewController, IndicatorInfoProvider {
    
    var detailsview : DeviceTableViewCell!
    var isExpanded = false
    let detailsBarHeight : CGFloat = 340
    var deviceList: [Device]! = []
    var prevSelectedMarker: GMSMarker?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        initView()
        loadMarker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isExpanded {
            hideDeviceDetails()
        }
    }
    
    func updateDeviceDetails(device: Any) {
        
        if let deviceData = device as? Device {
            detailsview.deviceLabel.text = deviceData.device_id
            detailsview.binTypeLabel.text = deviceData.bin_type
            detailsview.depthLabel.text = "\(String(describing: deviceData.depth!))" + "cm".localized()
            detailsview.fillLabel.text = "\(String(describing: deviceData.fill_percentage!))" + "%"
            detailsview.batteryStatusLabel.text = deviceData.battery_status! ? "full".localized() : "empty".localized()
            detailsview.batteryStatusLabel.textColor = deviceData.battery_status! ? UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1) : UIColor(red: 221/255, green: 0, blue: 51/255, alpha: 1)
            detailsview.fillLabel.textColor = deviceData.fill_percentage! > 85 ? UIColor(red: 221/255, green: 0, blue: 51/255, alpha: 1) : .black
            Utils.getAddressFromLatLong(lat: deviceData.latitude!, lon: deviceData.longitude!, completion: { (address) in
                self.detailsview.addressLabel.text = address
            })
            
        }
        
        
    }
    
    func initView() {
        if detailsview == nil {
            let nib = UINib(nibName: Constant.deviceTableViewCell, bundle: nil)
            detailsview = nib.instantiate(withOwner: self, options: nil).first as? DeviceTableViewCell
            detailsview.addressView.isHidden = false
            detailsview.statusView.isHidden = false
            detailsview.arrowImageView.image = UIImage(named: "ic_close")
            detailsview.frame = self.view.bounds
            detailsview.frame.size.height = detailsBarHeight
            detailsview.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
            view.addSubview(detailsview)
            view.backgroundColor = .clear
            detailsview.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            detailsview.clipsToBounds = false
            //MARK:click handler
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideDeviceDetails))
            detailsview.arrowImageView.addGestureRecognizer(tap)
            
            //MARK:shadow..
            detailsview.layer.shadowOpacity = 0.4
            detailsview.layer.shadowColor = UIColor.lightGray.cgColor
            
            detailsview.layoutIfNeeded()
        }
    }
    
    @objc func hideDeviceDetails() {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.detailsview.frame.origin.y = self.view.frame.size.height
        }
        animator.startAnimation()
        isExpanded = false
        prevSelectedMarker = nil
    }
    
    func showDeviceDetails(device: Any) {
        var delay = 0.0
        if isExpanded {
            delay = 0.5
            hideDeviceDetails()
        }
        
        UIView.animate(withDuration: 0.9, animations:{
        },completion: { _ in
            self.updateDeviceDetails(device: device)
        })
        
        UIView.animate(withDuration: 0.5, delay: delay, animations: {
            
            self.detailsview.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - self.detailsview.frame.size.height - self.view.safeAreaInsets.bottom)
        })
        
        isExpanded = true
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Map")
    }
}

extension MapVC : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if prevSelectedMarker != marker {
            showDeviceDetails(device: marker.userData as Any)
            prevSelectedMarker = marker
        }
        
        return false
    }
    
    func loadMarker() {
        
        var bounds  = GMSCoordinateBounds()
        for device in self.deviceList {
            let position = CLLocationCoordinate2D(latitude: device.latitude!, longitude: device.longitude!)
            let marker = GMSMarker(position: position)
            
            if device.fill_percentage! >= 85 {
                marker.iconView = UIImageView(image: UIImage(named: "ic_red_marker"))
            } else if device.fill_percentage! >= 15 {
                marker.iconView = UIImageView(image: UIImage(named: "ic_yellow_marker"))
            } else {
                marker.iconView = UIImageView(image: UIImage(named: "ic_green_marker"))
            }
            marker.map = mapView
            marker.userData = device
            bounds = bounds.includingCoordinate(marker.position)
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 70 , left: 30 ,bottom: 30 ,right: 30)))
    }
}
