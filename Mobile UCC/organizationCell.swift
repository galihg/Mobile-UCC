//
//  organizationCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/27/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class organizationCell: UITableViewCell {

    @IBOutlet weak var namaOrganisasi: UILabel!
    @IBOutlet weak var posisi: UILabel!
    @IBOutlet weak var thn_mulai: UILabel!
    @IBOutlet weak var thn_selesai: UILabel!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!

    
    
    
    var organisasi: Organisasi! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        namaOrganisasi.text = organisasi.nama_organisasi
        posisi.text = organisasi.posisi
        thn_mulai.text = organisasi.year_in
        thn_selesai.text = organisasi.year_out
      
    }
    
    
    
    
}
