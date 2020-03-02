//
//  LoginVC.swift
//  
//
//  Created by Geotech Infoservices Private Limited on 14/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        logInButton.layer.cornerRadius = 4
        userNameText.becomeFirstResponder()
        
    }
    
  
    func validateForm() -> Bool {
        let usernameValid = ValidatorUtil.isValidLength(self.userNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines), min: 1)
        let passwordValidLength = ValidatorUtil.isValidLength(self.passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines), min: 1)
        
        if !usernameValid {
            self.showAlertOnlyDismiss(title: "error".localized(), message: "error_invalid_username_length".localized())
            return false
        }
        if !passwordValidLength {
            self.showAlertOnlyDismiss(title: "error".localized(), message: "error_invalid_password_length_login".localized())
            return false
        }
        
        return true
    }
    
    @IBAction func clickOnLogin(_ sender: Any) {
        
        if !userNameText.text!.isEmpty && userNameText.isFirstResponder {
            passwordText.becomeFirstResponder()
            return
        }
        
        if !validateForm() {
            return
        }
        
        showSpinner(onView: self.view)
        let userName: String = userNameText.text!
        let password: String = passwordText.text!
        
        NetworkManager.manager.login(id: userName, password: password)
            .responseJSON { (response) in
                self.removeSpinner()
                switch response.result {
                    case .success:
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                            return
                        }
                        KeyChainManager.saveTokenResponse(accessToken: getResponse.access_token!, refreshToken: getResponse.refresh_token!)
                        KeyChainManager.saveUserDetails(tokenResponse: getResponse)
                        
                        self.view.window?.rootViewController = ContainerVC()
                        self.view.window?.makeKeyAndVisible()
                      
                    case .failure:
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(OnlyMessageResponse.self, from: data) else {
                            return
                        }
                        self.showAlertOnlyDismiss(title: "error".localized(), message: getResponse.message!)
                       
                }
        }
    }
}


