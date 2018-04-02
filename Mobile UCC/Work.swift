//
//  Work.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 22/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Work
{
    var id_pekerjaan: String?
    var id_member: String?
    var perusahaan: String?
    var posisi: String?
    var deskripsi: String?
    var year_in: String?
    var year_out: String?
    var ipk: String?
    
    init(id_pekerjaan: String, id_member: String, perusahaan: String, posisi: String, deskripsi: String)
    {
        self.id_pekerjaan = id_pekerjaan
        self.id_member = id_member
        self.perusahaan = perusahaan
        self.posisi = posisi
        self.deskripsi = deskripsi
    }
    
}
