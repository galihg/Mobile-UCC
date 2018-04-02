//
//  History.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 24/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class History
{
    var id_vacancy: Int?
    var company_name: String?
    var company_logo: URL?
    var vacancy_name: String?
    var tgl_apply: String?
    var status_apply: Int?
    var status_cancel: Bool?
    
    init(company_name: String, id_vacancy: Int, company_logo: URL, status_apply: Int, vacancy_name: String, tgl_apply: String, status_cancel: Bool)
    {
        self.company_name = company_name
        self.id_vacancy = id_vacancy
        self.company_logo = company_logo
        self.vacancy_name = vacancy_name
        self.tgl_apply = tgl_apply
        self.status_apply = status_apply
        self.status_cancel = status_cancel
        
    }
}

