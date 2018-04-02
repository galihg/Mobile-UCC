//
//  Rekomendasi.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 23/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Rekomendasi
{
    var id_rekomendasi: String?
    var id_member: String?
    var nama_rekomendasi: String?
    var posisi: String?
    var no_telp: String?
    var alamat: String?
    
    init(id_rekomendasi: String, id_member: String, nama_rekomendasi: String, posisi: String, no_telp: String, alamat: String)
    {
        self.id_rekomendasi = id_rekomendasi
        self.id_member = id_member
        self.nama_rekomendasi = nama_rekomendasi
        self.posisi = posisi
        self.no_telp = no_telp
        self.alamat = alamat
    }
    
}




