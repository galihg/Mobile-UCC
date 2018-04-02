//
//  Vacancy.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/7/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import Foundation

class Vacancy
{
    var id_vacancy: Int?
    var company_name: String?
    var company_logo: URL?
    var total_vacancy: Int?
    var industry_type: String?
    
    init(company_name: String, id_vacancy: Int, company_logo: URL, total_vacancy: Int, industry_type: String)
    {
        self.company_name = company_name
        self.id_vacancy = id_vacancy
        self.company_logo = company_logo
        self.total_vacancy = total_vacancy
        self.industry_type = industry_type
        
    }
}
