//
//  Merchant.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import Foundation

struct Merchant
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
    
    /*init(banner: URL, valid: String, id_merchant: String, logo: URL, name: String, address: String, desc: String, joined: String, contact: String, email: String, web: String)
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
    }*/

}

class MerchantModel
{
    var merchants = [Merchant]()
    
    init(merchantsArray: [[String:Any]]) {
        for merchantDictionary in merchantsArray {
            let valid = merchantDictionary["date_expired"] as? String ?? ""
            let id_merchant = merchantDictionary["id_merchant"] as! String
            let name = merchantDictionary["name"] as! String
            let address = merchantDictionary["address"] as? String ?? ""
            let desc = merchantDictionary["promo_desc"] as? String ?? ""
            let joined = merchantDictionary["date_registered"] as? String ?? ""
            let contact = merchantDictionary["contact"] as? String ?? ""
            let email = merchantDictionary["email"] as? String ?? ""
            let web = merchantDictionary["website"] as? String ?? ""
            
            // image URL
            let banner = URL(string: merchantDictionary["banner_img_url"] as! String)
            let logo = URL(string: merchantDictionary["logo_url"] as! String)
            
            self.merchants.append(Merchant(banner: banner!, valid: valid, id_merchant: id_merchant, logo: logo!, name: name, address: address, desc: desc, joined: joined, contact: contact, email: email, web: web))
        }
        
    }
    
    
}
