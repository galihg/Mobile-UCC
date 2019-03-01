//
//  Alert.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 19/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class Alert: UIViewController {
    
    static func showMessage(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
