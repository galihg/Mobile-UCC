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
    
    init(merchantDictionary: [String : Any]) {
        valid = merchantDictionary["date_expired"] as? String
        id_merchant = merchantDictionary["id_merchant"] as? String
        name = merchantDictionary["name"] as? String
        address = merchantDictionary["address"] as? String
        desc = merchantDictionary["promo_desc"] as? String
        joined = merchantDictionary["date_registered"] as? String ?? "nil"
        contact = merchantDictionary["contact"] as? String ?? "nil"
        email = merchantDictionary["email"] as? String ?? "nil"
        web = merchantDictionary["website"] as? String ?? "nil"
        
        // image URL
        banner = URL(string: merchantDictionary["banner_img_url"] as! String)
        logo = URL(string: merchantDictionary["logo_url"] as! String)
        
        
    }
    
    static func downloadAllMerchant() -> [Merchant]
    {
        var merchant = [Merchant]()
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/merchant/list")
        let jsonData = try? Data(contentsOf: url!)
        
        if let jsonDictionary = NetworkService.parseJSONFromData(jsonData) {
            let merchantDictionaries = jsonDictionary["data"] as! [[String : Any]]
            for merchantDictionary in merchantDictionaries {
                let newMerchant = Merchant(merchantDictionary: merchantDictionary)
                merchant.append(newMerchant)
            }
        }
        
        return merchant
    }
}
