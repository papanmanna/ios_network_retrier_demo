//
//  DeviceTableViewCell.swift
//  SmartBins
//
//  Created by GeoTech Infoservices Private Limited on 23/01/20.
//  Copyright © 2020 Geotech Infoservices Private Limited. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var fillLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var binTypeLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var batteryStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addressLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
