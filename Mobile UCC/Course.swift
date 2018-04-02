//
//  Course.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 24/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Course
{
    var id_ctc: String?
    var id_member: String?
    var nama_kursus: String?
    var tahun: String?
    var organizer: String?
    var sertifikat: String?
    
    init(id_ctc: String, id_member: String, nama_kursus: String, tahun: String, organizer: String, sertifikat: String)
    {
        self.id_ctc = id_ctc
        self.id_member = id_member
        self.nama_kursus = nama_kursus
        self.tahun = tahun
        self.organizer = organizer
        self.sertifikat = sertifikat
    }
    
}

