//
//  MenuVC.swift
//
//  Created by Geotech Infoservices Private Limited on 15/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var crmIdLabel: UILabel!
    @IBOutlet weak var logoutView: UIView!

    @IBOutlet weak var emptyView: UIView!
    
    var homeDelegate : HomeControllerDelegate?
    var delegate : ItemMenuDelegate?
    let menuItem = ["devices".localized(), "change_password".localized()]
    let menuImage = [UIImage(named: "ic_device"), UIImage(named: "ic_change_password")]
    let menuImageActive = [UIImage(named: "ic_device_active"), UIImage(named: "ic_change_password_active")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logOutTap = UITapGestureRecognizer(target: self, action: #selector(logout))
        logoutView.addGestureRecognizer(logOutTap)
        let closeMenuTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTogle))
        emptyView.addGestureRecognizer(closeMenuTap)
        setupTableView()
        if let crmId = KeyChainManager.getUserId() {
            crmIdLabel.text = crmId
        }
        if let name = KeyChainManager.getUserName() {
            userNameLabel.text = name
        }
    }
    @objc func logout() {
        self.logoutFromView()
    }
    @objc func handleMenuTogle() {
        homeDelegate?.handleMenutoggle()
    }
    private func setupTableView() {
        let nib = UINib(nibName: "ItemMenuCellTableViewCell", bundle: nil)
        menuTableView.register(nib, forCellReuseIdentifier: "menuItem")
        let indexPath = IndexPath(row: 0, section: 0)
        menuTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
    }
}
extension MenuVC : UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "menuItem", for: indexPath) as! ItemMenuCellTableViewCell
        
        cell.itemTitle.text = menuItem[indexPath.row]
        cell.itemImage.image = menuImage[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                delegate?.configureHome(storyboard: "HomeSB", identifier: "HomeVC")
            
            case 1:
                delegate?.configureHome(storyboard: "ChangePasswordSB", identifier: "ChangePasswordVC")
        
            default:
                ()
            
        }
    }
}
