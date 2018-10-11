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
    
    var jenjang = ["03-SMA": "SMA/SMK Sederajat", "21-S1": "Strata I", "31-S2": "Strata II", "41-S3": "Strata III", "22-PR": "Profesi" , "11-D1": "Diploma I", "12-D2": "Diploma II", "13-D3": "Diploma III", "14-D4": "Diploma IV"]


    var pendidikan: Pendidikan! {
        didSet {
            self.updateUI()
        }
    }
    
    func filterDegree(_ degreeDictionary: Dictionary<String, String>, _ id: String) -> String {
        var filteredString: String!
        for (kode, degree) in degreeDictionary {
            if (kode == id) {
                filteredString = degree
            }
        }
        return filteredString
    }
    
    func updateUI()
    {
        let degreeName = filterDegree(jenjang, pendidikan.degree!)
        degree.text = degreeName
        univ.text = pendidikan.univ_name
        major.text = pendidikan.major
        timeStudy.text = pendidikan.year_in! + "-" + pendidikan.year_out!
        ipk.text = pendidikan.ipk
    }
    
    
}
