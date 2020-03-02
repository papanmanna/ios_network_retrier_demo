//
//  ValidatorUtil.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 21/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import Foundation


class ValidatorUtil {
    
    static func isValidPassword(_ str:String?) -> Bool {
        let regEx = "(?=^.{8,}$)(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&amp;*()_+}{&quot;:;'?/&gt;.&lt;,])(?!.*\\s).*$"

        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: str)
    }

    static func isValidLength(_ stringToCheck: String?, min: Int = 0, max: Int = 255) -> Bool {
        guard let value = stringToCheck else {
            return false
        }
        if value.count < min || value.count > max {
            return false
        }
        return true
    }
}
