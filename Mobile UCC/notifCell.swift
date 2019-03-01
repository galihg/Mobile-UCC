//
//  notifCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 9/4/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class notifCell: UITableViewCell {

    @IBOutlet weak var type_icon: UIImageView!
    @IBOutlet weak var type_label: UILabel!
    @IBOutlet weak var subject_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var status_label: UILabel!

    
    
    var notifikasi: Notifikasi! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        type_label.text = notifikasi.type_notif
        subject_label.text = notifikasi.subject_notif
        date_label.text = notifikasi.date_notif
        
        let status_notif = notifikasi.status
        
        if (status_notif == true) {
            status_label.text = ""
        } else {
            status_label.text = "New"
        }
        
        if (type_label.text == "warning") {
            type_icon.image = UIImage(named: "warning_icon")
        } else if (type_label.text == "info") {
            type_icon.image = UIImage(named: "info_icon")
        } else {
            type_icon.image = UIImage(named: "error_icon")
        }
        
    }
}


