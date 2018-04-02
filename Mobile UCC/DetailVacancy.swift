//
//  DetailVacancy.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 19/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class DetailVacancy
    
{
    var id_vacancy: String?
    var total_applicants: Int?
    var remaining_days: Int?
    var vacancy_name: String?
    var deadline: String?
    var apply_online: Bool?
    var job_position: String?
    var min_education: String?
    var type_vacancy: String?
    var assignment: String?
    
    init(id_vacancy: String, total_applicants: Int, remaining_days: Int, vacancy_name: String, deadline: String, apply_online: Bool, job_position: String, min_education: String, type_vacancy: String, assignment: String)
    {
        self.id_vacancy = id_vacancy
        self.total_applicants = total_applicants
        self.remaining_days = remaining_days
        self.vacancy_name = vacancy_name
        self.deadline = deadline
        self.apply_online = apply_online
        self.job_position = job_position
        self.min_education = min_education
        self.type_vacancy = type_vacancy
        self.assignment = assignment
        
    }
}
