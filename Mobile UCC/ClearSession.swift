//
//  ClearSession.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 11/03/19.
//  Copyright © 2019 LabSE Siskom. All rights reserved.
//

import Foundation
import KeychainSwift


let session_end_message = "Login session has ended, please login again"

class ClearSession {
    static func delete_session() {
        let keychain = KeychainSwift()
        let preferences = UserDefaults.standard
    
        keychain.clear()
        preferences.removeObject(forKey: "session")
       
        Alert.showMessage(title: "WARNING!", msg: session_end_message)
    
        NotificationCenter.default.post(name: .updatePhoto, object: nil)
        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
        NotificationCenter.default.post(name: .reload, object: nil)
    }
}
