//
//  awardCell.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 07/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit

class awardCell: UITableViewCell {

    @IBOutlet weak var namaAward: UILabel!
    @IBOutlet weak var waktuAward: UILabel!
    @IBOutlet weak var namaAppreciator: UILabel!
    
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    
    
    
    
    
    var award: Award! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        
        namaAward.text = award.nama_prestasi
        waktuAward.text = award.tahun
        namaAppreciator.text = award.pemberi

    }
}
