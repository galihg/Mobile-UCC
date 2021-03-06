//
//  Expertise.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class EditSkill: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var teknis: UITextView!
    @IBOutlet weak var nonTeknis: UITextView!
    @IBOutlet weak var komputer: UITextView!
    @IBOutlet weak var otherSkill: UITextView!

    var passedData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Skills"
        
        // Do any additional setup after loading the view.
        
        auth_check()
        
        teknis.delegate = self
        nonTeknis.delegate = self
        komputer.delegate = self
        otherSkill.delegate = self
        
        teknis.text = passedData[0]
        nonTeknis.text = passedData[1]
        komputer.text = passedData[2]
        otherSkill.text = passedData[3]
        
        teknis.layer.borderWidth = 1.0
        nonTeknis.layer.borderWidth = 1.0
        komputer.layer.borderWidth = 1.0
        otherSkill.layer.borderWidth = 1.0
        
    }
    
    func auth_check() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                    
                } else if (status == "invalid-session"){
                    let keychain = KeychainSwift()
                    let preferences = UserDefaults.standard
                    
                    keychain.clear()
                    preferences.removeObject(forKey: "session")
                    
                    Alert.showMessage(title: "WARNING!", msg: session_end_message)
                    
                    DispatchQueue.main.async {
                        HUD.hide()
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
        teknis.resignFirstResponder()
        nonTeknis.resignFirstResponder()
        komputer.resignFirstResponder()
        otherSkill.resignFirstResponder()
    }
    
    @IBAction func submitSkill(_ sender: Any) {
        resignResponder()
        
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/skill"
        
        let paramToSend = "teknis=" + teknis.text! + "&non_teknis=" + nonTeknis.text!
        let paramToSend2 = "&komputer=" + komputer.text! + "&lainnya=" + otherSkill.text!
        
        let paramFinal = paramToSend + paramToSend2
        
        NetworkService.parseJSONFromURL(url, "POST", parameter: paramFinal){ (server_response) in
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.layoutIfNeeded()
    
        return true
        
    }
    
}
