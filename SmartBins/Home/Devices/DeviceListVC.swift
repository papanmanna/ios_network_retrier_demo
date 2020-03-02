//
//  DeviceListVC.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 23/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DeviceListVC: UIViewController, IndicatorInfoProvider {
    
    
    @IBOutlet weak var deviceListTableView: UITableView!
    @IBOutlet weak var deviceCountLabel: UILabel!
    
    var deviceList: [Device]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setDeviceList()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: Constant.deviceTableViewCell, bundle: nil)
        deviceListTableView.register(nib, forCellReuseIdentifier: Constant.deviceItem)
        deviceListTableView.tableFooterView = UIView()
    }
    
    
    func setDeviceList() {
        self.deviceCountLabel.text = (deviceList.count > 0 ? "\(String(describing: deviceList.count))" : "no".localized())
        self.deviceCountLabel.text! += deviceList.count > 1 ? "devices_registered".localized() :"device_registered".localized()
        self.deviceListTableView.reloadData()
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "List")
    }
}

extension DeviceListVC :  UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = deviceListTableView.dequeueReusableCell(withIdentifier: Constant.deviceItem, for: indexPath) as! DeviceTableViewCell
        
        cell.deviceLabel.text = self.deviceList[indexPath.row].device_id!
        cell.binTypeLabel.text = self.deviceList[indexPath.row].bin_type
        cell.depthLabel.text = "\(String(describing: self.deviceList[indexPath.row].depth!))" + "cm".localized()
        cell.fillLabel.text = "\(String(describing: self.deviceList[indexPath.row].fill_percentage!))" + "%"
        cell.batteryStatusLabel.text = self.deviceList[indexPath.row].battery_status! ? "full".localized() : "empty".localized()
        cell.batteryStatusLabel.textColor = self.deviceList[indexPath.row].battery_status! ? UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1) : UIColor(red: 221/255, green: 0, blue: 51/255, alpha: 1)
        cell.fillLabel.textColor = self.deviceList[indexPath.row].fill_percentage! > 85 ? UIColor(red: 221/255, green: 0, blue: 51/255, alpha: 1) : .black
        
        Utils.getAddressFromLatLong(lat: self.deviceList[indexPath.row].latitude!, lon: self.deviceList[indexPath.row].longitude!, completion: { (address) in
            cell.addressLabel.text = address
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = deviceListTableView.cellForRow(at: indexPath)  as? DeviceTableViewCell {
            cell.addressView.isHidden = !cell.addressView.isHidden
            cell.statusView.isHidden = !cell.statusView.isHidden
            cell.arrowImageView.transform = !cell.statusView.isHidden ? CGAffineTransform(rotationAngle: CGFloat.pi) : CGAffineTransform.identity
            cell.statusView.isHidden ? UIView.setAnimationsEnabled(false) : UIView.setAnimationsEnabled(true)
            deviceListTableView.beginUpdates()
            deviceListTableView.endUpdates()
            deviceListTableView.deselectRow(at: indexPath, animated: true)
            UIView.setAnimationsEnabled(true)
        }
    }
}
