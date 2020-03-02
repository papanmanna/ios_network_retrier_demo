//
//  ChangePasswordVC.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 19/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var crmIdLabel: UILabel!
    @IBOutlet weak var oldPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var rePassTF: UITextField!
    
    var delegate : HomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        saveBtn.layer.cornerRadius = 4
        oldPassTF.becomeFirstResponder()
        if let crmId = KeyChainManager.getUserId() {
            crmIdLabel.text = crmId
        }
        
        if let name = KeyChainManager.getUserName() {
            nameLabel.text = name
        }
    }
    
    func validateForm() -> Bool {
        
        let oldPassValidLength = ValidatorUtil.isValidLength(self.oldPassTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), min: 1)
        let newPassValidLength = ValidatorUtil.isValidLength(self.newPassTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), min: 8)
        let rePassValidLength = ValidatorUtil.isValidLength(self.rePassTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), min: 1)
       
        
        if !oldPassValidLength {
            self.showAlertOnlyDismiss(title: "error".localized(), message: "error_invalid_password_length_login".localized())
            return false
        }
        
        
        if !newPassValidLength {
            self.showAlertOnlyDismiss(title: "error".localized(), message: "error_invalid_new_password_length".localized())
            return false
        }
        
        
        if !rePassValidLength {
            self.showAlertOnlyDismiss(title: "error".localized(), message: "error_invalid_re_password_length".localized())
            return false
        }
        
        if self.newPassTF.text != self.rePassTF.text {
            self.showAlertOnlyDismiss(title: "error".localized(), message: "error_password_mismatch".localized())
            return false
        }
        
        return true
    }
    
    
    @IBAction func clickOnChangePassword(_ sender: Any) {
        
        if !oldPassTF.text!.isEmpty && oldPassTF.isFirstResponder {
            newPassTF.becomeFirstResponder()
            return
        }
        
        if !newPassTF.text!.isEmpty && newPassTF.isFirstResponder {
            rePassTF.becomeFirstResponder()
            return
        }
        
        if !validateForm() {
            return
        }
        
        showSpinner(onView: self.view)
        
        let oldPassword: String = oldPassTF.text!
        let newPassword: String = newPassTF.text!
        
        NetworkManager.manager.changePassword(oldPassword: oldPassword, newPassword: newPassword).responseJSON { (response) in
            self.removeSpinner()
            
            guard let data = response.data, let getResponse = try? JSONDecoder().decode(OnlyMessageResponse.self, from: data) else {
                return
            }
            
            switch response.result {
                case .success:
                    self.oldPassTF.text?.removeAll()
                    self.newPassTF.text?.removeAll()
                    self.rePassTF.text?.removeAll()
                    self.showAlertOnlyDismiss(title: "success".localized(), message: getResponse.message!)
                
                case .failure:
                    if response.response?.statusCode == 401 {
                        self.logoutFromView()
                        return
                    }
                    self.showAlertOnlyDismiss(title: "error".localized(), message: getResponse.message!)
                    
            }
        }
    }
    
    
    @objc func handleMenuTogle() {
        self.oldPassTF.resignFirstResponder()
        self.newPassTF.resignFirstResponder()
        self.rePassTF.resignFirstResponder()
        delegate?.handleMenutoggle()
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 221/255, green: 0, blue: 51/255,alpha: 1)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "change_password".localized().localizedUppercase
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 20)!]
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal) , style: .plain, target: self, action: #selector(handleMenuTogle))
    }
}
