//
//  Organisasi.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 23/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Organisasi
{
    var id_organisasi: String?
    var id_member: String?
    var nama_organisasi: String?
    var posisi: String?
    var deskripsi: String?
    var year_in: String?
    var year_out: String?
    var active: String?
    
    init(id_organisasi: String, id_member: String, nama_organisasi: String, posisi: String, deskripsi: String, year_in: String, year_out: String, active: String)
    {
        self.id_organisasi = id_organisasi
        self.id_member = id_member
        self.nama_organisasi = nama_organisasi
        self.posisi = posisi
        self.deskripsi = deskripsi
        self.year_in = year_in
        self.year_out = year_out
        self.active = active
    }
    
}





