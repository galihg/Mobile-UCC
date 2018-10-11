//
//  JobType.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 15/09/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class JobType
{
    var id_tipe: String?
    var deskripsi: String?
    
    init(id_tipe: String, deskripsi: String)
    {
        self.id_tipe = id_tipe
        self.deskripsi = deskripsi
    }
}
