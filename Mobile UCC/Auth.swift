//
//  Auth.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 19/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Auth: BaseViewController {
    
    static func auth_check() {
        
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    
                    DispatchQueue.main.async {
                        return
                    }
                    
                } else if (status == "invalid-session"){
                    
                    let preferences = UserDefaults.standard
                    preferences.removeObject(forKey: "session")
                    
                    DispatchQueue.main.async {
                        
                        Alert.showMessage(title: "WARNING!", msg: "Sesi Login telah berakhir, silahkan login ulang")
                        
                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                        NotificationCenter.default.post(name: .reload, object: nil)
                    }
                    
                }
            }
            
        }
        
    }
    
}
