//
//  Notification.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 21/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Notifikasi
{
    var id_notif: Int?
    var type_notif: String?
    var subject_notif: String?
    var status: Bool?
    var date_notif: String?
    
    init(id_notif: Int, type_notif: String, subject_notif: String, status: Bool, date_notif: String)
    {
        self.id_notif = id_notif
        self.type_notif = type_notif
        self.subject_notif = subject_notif
        self.status = status
        self.date_notif = date_notif
        
    }
}
