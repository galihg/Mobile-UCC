//
//  ChangePassword.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 13/10/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

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
        
        Auth.auth_check()
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
            if let message = server_response["message"] as? String {
                Alert.showMessage(title: "WARNING!", msg: message)
                
                DispatchQueue.main.async {
                    HUD.hide()
                }
            }
        }
    }
    

}
