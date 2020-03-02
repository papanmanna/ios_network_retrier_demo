//
//  ItemMenuCellTableViewCell.swift
//
//  Created by GeoTech Infoservices Private Limited on 16/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit

class ItemMenuCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var parentView: UIView!
    
    let menuImage = [UIImage(named: "ic_device"), UIImage(named: "ic_change_password")]
    let menuImageActive = [UIImage(named: "ic_device_active"), UIImage(named: "ic_change_password_active")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        parentView.backgroundColor =  selected ? UIColor(red: 221/255, green: 0, blue: 51/255, alpha: 0.12) : .white
        itemTitle.textColor = selected ? UIColor(red: 221/255, green: 0, blue: 51/255,alpha: 1) : UIColor(red: 158/255, green: 158/255, blue: 158/255,alpha: 1)
        
        changeImage(selected, itemTitle.text)
        
        
    }
    
    func changeImage(_ selected: Bool, _ itemTitle: String?) {
        
        switch itemTitle {
            case "devices".localized() :
                itemImage.image = selected ? menuImageActive[0] : menuImage[0]
            
            case "change_password".localized():
                itemImage.image = selected ? menuImageActive[1] : menuImage[1]
            
            default:
                ()
        }
    }
    
}
