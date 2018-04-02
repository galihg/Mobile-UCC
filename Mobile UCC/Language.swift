//
//  Language.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 22/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Language
{
    var id_bahasa: String?
    var id_member: String?
    var bahasa: String?
    var kemampuan: String?
    
    
    init(id_bahasa: String, id_member: String, bahasa: String, kemampuan: String)
    {
        self.id_bahasa = id_bahasa
        self.id_member = id_member
        self.bahasa = bahasa
        self.kemampuan = kemampuan
    }
    
}
