//
//  Portofolios.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 24/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Portofolios
{
    var id_portofolio: String?
    var id_member: String?
    var title: String?
    var tgl_mulai: String?
    var tgl_selesai: String?
    var alamat_URL: String?
    var deskripsi: String?
    
    init(id_portofolio: String, id_member: String, title: String, tgl_mulai: String, tgl_selesai: String, alamat_URL: String, deskripsi: String)
    {
        self.id_portofolio = id_portofolio
        self.id_member = id_member
        self.title = title
        self.tgl_mulai = tgl_mulai
        self.tgl_selesai = tgl_selesai
        self.alamat_URL = alamat_URL
        self.deskripsi = deskripsi
    }
    
}

