//
//  languageCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/21/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class languageCell: UITableViewCell {

    @IBOutlet var language: UILabel!
    @IBOutlet var skill: UILabel!
    @IBOutlet var btn_edit: UIButton!
    @IBOutlet var btn_delete: UIButton!


    
    
    
    var bahasa: Language! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        let langRaw = bahasa.bahasa
        if (langRaw == "1") {
            language.text = "Jepang"
        } else if (langRaw == "2") {
            language.text = "Perancis"
        } else if (langRaw == "3") {
            language.text = "Mandarin"
        } else if (langRaw == "4") {
            language.text = "Korea"
        } else if (langRaw == "5") {
            language.text = "Belanda"
        } else if (langRaw == "6") {
            language.text = "Inggris"
        } else {
            language.text = "Jerman"
        }

        let skillRaw = bahasa.kemampuan
        if (skillRaw == "1") {
            skill.text = "Pemula"
        } else if (skillRaw == "2") {
            skill.text = "Menengah"
        } else {
            skill.text = "Mahir"
        }
    }
}
