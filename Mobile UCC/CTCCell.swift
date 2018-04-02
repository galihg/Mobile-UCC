//
//  CTCCell.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 15/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit

class CTCCell: UITableViewCell {

    @IBOutlet weak var year1: UILabel!
    @IBOutlet weak var nama: UILabel!
    @IBOutlet weak var year2: UILabel!
    @IBOutlet weak var organizer: UILabel!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    
    
    
    
    
    var course: Course! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        year1.text = course.tahun
        nama.text = course.nama_kursus
        year2.text = course.tahun
        organizer.text = course.organizer
        
    }
    
}
