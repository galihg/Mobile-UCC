//
//  Auth.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 19/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation
import KeychainSwift

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
                    
                    ClearSession.delete_session()
                    
                }
            }
            
        }
        
    }
    
}
