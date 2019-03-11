//
//  ChangePassword.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 13/10/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class ChangePassword: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var _oldPassword: UITextField!
    @IBOutlet weak var _newPassword: UITextField!
    @IBOutlet weak var _confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        self.title = "Change Password"
        
        _oldPassword.delegate = self
        _newPassword.delegate = self
        _confirmPassword.delegate = self
        
        auth_check()
    }
    
    func auth_check() {
        
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    
                    DispatchQueue.main.async {
                        return
                    }
                    
                } else if (status == "invalid-session"){
                    let keychain = KeychainSwift()
                    let preferences = UserDefaults.standard
                    
                    keychain.clear()
                    preferences.removeObject(forKey: "session")
                    
                    Alert.showMessage(title: "WARNING!", msg: session_end_message)
                    
                    DispatchQueue.main.async {
                        self.openViewControllerBasedOnIdentifier("Home")
                        
                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                        NotificationCenter.default.post(name: .reload, object: nil)
                    }
                    
                }
            }
            
        }
        
    }
    
    func resignResponder() {
        _oldPassword.resignFirstResponder()
        _newPassword.resignFirstResponder()
        _confirmPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func changePassword(_ sender: Any) {
        resignResponder()
        HUD.show(.progress)
        
        let oldPassword = _oldPassword.text
        let newPassword = _newPassword.text
        let confirmPassword = _confirmPassword.text
        
        let data1 = oldPassword!.data(using: String.Encoding.utf8)
        let data2 = newPassword!.data(using:String.Encoding.utf8)
        let data3 = confirmPassword!.data(using: String.Encoding.utf8)
        
        let auth_oldPW = data1!.base64EncodedString()
        let auth_newPW = data2!.base64EncodedString()
        let auth_confirmPW = data3!.base64EncodedString()
        
        let paramToSend = "oldpasswd=" + auth_oldPW + "&newpasswd1=" + auth_newPW + "&newpasswd2=" + auth_confirmPW
        let url = "http://api.career.undip.ac.id/v1/auth/changepassword"
        
        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String {
                if let message = server_response["message"] as? String {
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                    if (status == "ok"){
                        Alert.showMessage(title: "SUCCESS!", msg: message)
                    } else {
                        Alert.showMessage(title: "WARNING!", msg: message)
                    }
                }
            }
            
        }
    }
    

}
