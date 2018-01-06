//
//  educationCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/9/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class educationCell: UITableViewCell {

    @IBOutlet var degree: UILabel!
    @IBOutlet var univ: UILabel!
    @IBOutlet var major: UILabel!
    @IBOutlet var timeStudy: UILabel!
    @IBOutlet var ipk: UILabel!
    @IBOutlet var btn_edit: UIButton!
    @IBOutlet var btn_delete: UIButton!
    



    var pendidikan: Pendidikan! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {

        degree.text = pendidikan.degree
        univ.text = pendidikan.univ_name
        major.text = pendidikan.major
        timeStudy.text = pendidikan.year_in! + "-" + pendidikan.year_out!
        ipk.text = pendidikan.ipk
    }
    
    
}
