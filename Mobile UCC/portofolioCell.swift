//
//  portofolioCell.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 16/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit

class portofolioCell: UITableViewCell {

    @IBOutlet weak var judul: UILabel!
    @IBOutlet weak var tglMulai: UILabel!
    @IBOutlet weak var tglSelesai: UILabel!
    @IBOutlet weak var alamatURL: UITextView!
    @IBOutlet weak var deskripsi: UILabel!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    
    
    
    var portofolios: Portofolios! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        
        judul.text = portofolios.title
        tglMulai.text = portofolios.tgl_mulai
        tglSelesai.text = portofolios.tgl_selesai
        alamatURL.text = portofolios.alamat_URL
        deskripsi.text = portofolios.deskripsi
    }

}
