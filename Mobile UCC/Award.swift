//
//  Award.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 23/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Award
{
    var id_prestasi: String?
    var id_member: String?
    var nama_prestasi: String?
    var pemberi: String?
    var tahun: String?
    var keterangan: String?
    
    init(id_prestasi: String, id_member: String, nama_prestasi: String, pemberi: String, tahun: String, keterangan: String)
    {
        self.id_prestasi = id_prestasi
        self.id_member = id_member
        self.nama_prestasi = nama_prestasi
        self.pemberi = pemberi
        self.tahun = tahun
        self.keterangan = keterangan
    }
    
}
