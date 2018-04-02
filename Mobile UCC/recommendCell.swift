//
//  recommendCell.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 08/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit

class recommendCell: UITableViewCell {

    @IBOutlet weak var nama_rekomendasi: UILabel!
    @IBOutlet weak var posisi: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    
    
    
    
    var rekomendasi: Rekomendasi! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        nama_rekomendasi.text = rekomendasi.nama_rekomendasi
        posisi.text = rekomendasi.posisi
        phone.text = rekomendasi.no_telp
        
    }
    
}
