//
//  Pendidikan.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 22/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Pendidikan
{
    var id_education: String?
    var id_member: String?
    var degree: String?
    var univ_name: String?
    var major: String?
    var year_in: String?
    var year_out: String?
    var ipk: String?
    
    init(id_education: String, id_member: String, degree: String, univ_name: String, major: String, year_in: String, year_out: String, ipk: String)
    {
        self.id_education = id_education
        self.id_member = id_member
        self.degree = degree
        self.univ_name = univ_name
        self.major = major
        self.year_in = year_in
        self.year_out = year_out
        self.ipk = ipk
    }
    
}
