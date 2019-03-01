//
//  Merchant.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import Foundation

class Merchant
{
    var banner: URL?
    var valid: String?
    var id_merchant : String?
    var logo : URL?
    var name : String?
    var address : String?
    var desc : String?
    var joined : String?
    var contact : String?
    var email : String?
    var web : String?
    
    init(banner: URL, valid: String, id_merchant: String, logo: URL, name: String, address: String, desc: String, joined: String, contact: String, email: String, web: String)
    {
        self.banner = banner
        self.valid = valid
        self.id_merchant = id_merchant
        self.logo = logo
        self.name = name
        self.address = address
        self.desc = desc
        self.joined = joined
        self.contact = contact
        self.email = email
        self.web = web
    }

}
