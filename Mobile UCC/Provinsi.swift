//
//  Provinsi.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 19/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

struct Provinsi
{
    var id_provinsi: String?
    var nama_provinsi: String?
   
    init(id_provinsi: String, nama_provinsi: String)
    {
        self.id_provinsi = id_provinsi
        self.nama_provinsi = nama_provinsi
    }
    
    init(provinceDictionary: [String:Any]) {
        id_provinsi = provinceDictionary["id"] as? String
        nama_provinsi = provinceDictionary["name"] as? String
    }
    
    static func downloadAllProvince() -> [Provinsi]
    {
        
        var provinsi = [Provinsi]()
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/location/provinces/")
        //let urlString = "http://api.career.undip.ac.id/v1/location/provinces/"
        let jsonData = try? Data(contentsOf: url!)
        
        if let jsonDictionary = NetworkService.parseJSONFromData(jsonData) {
            let provinceDictionaries = jsonDictionary["data"] as! [[String:Any]]
            for provinceDictionary in provinceDictionaries {
                let newProvince = Provinsi(provinceDictionary: provinceDictionary)
                provinsi.append(newProvince)
            }
        }
        
        /*NetworkService.parseJSONFromURL(urlString, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                
                if (status == "ok") {
                    let provinceDictionaries = server_response["data"] as! [[String:Any]]
                    var provinsi = [Provinsi]()
                    for provinceDictionary in provinceDictionaries {
         
                        provinsi.append(Provinsi(provinceDictionary: provinceDictionary))
                        return provinsi
                    }
                }
            }
            
        }*/
        print(provinsi)
        return provinsi
        //return nil
    }
}
