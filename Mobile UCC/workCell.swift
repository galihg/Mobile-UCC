//
//  workCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/20/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class workCell: UITableViewCell {

    @IBOutlet var companyName: UILabel!
    @IBOutlet var position: UILabel!
    @IBOutlet var work_desc: UILabel!
    @IBOutlet var btn_edit: UIButton!
    @IBOutlet var btn_delete: UIButton!
    
    
    
    var work: Work! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        
        companyName.text = work.perusahaan
        position.text = work.posisi
        work_desc.text = work.deskripsi
    }

}
