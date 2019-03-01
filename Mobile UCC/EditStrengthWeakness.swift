//
//  KelebihanDanKekurangan.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditStrengthWeakness: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var kelebihan: UITextView!
    @IBOutlet weak var kekurangan: UITextView!
    
    var passedData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Strength and Weakness"
        // Do any additional setup after loading the view.
        
        auth_check()
        
        kelebihan.delegate = self
        kekurangan.delegate = self
        
        kelebihan.text = passedData[0]
        kekurangan.text = passedData[1]
        
        kelebihan.layer.borderWidth = 1.0
        kekurangan.layer.borderWidth = 1.0
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
                    
                    let preferences = UserDefaults.standard
                    preferences.removeObject(forKey: "session")
                    
                    DispatchQueue.main.async {
                        HUD.hide()
                        self.openViewControllerBasedOnIdentifier("Home")
                        Alert.showMessage(title: "WARNING!", msg: "Sesi Login telah berakhir, silahkan login ulang")
                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                        NotificationCenter.default.post(name: .reload, object: nil)
                    }
                    
                }
            }
        }
    }
    
    func resignResponder() {
        kelebihan.resignFirstResponder()
        kekurangan.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.layoutIfNeeded()
        
        return true
        
    }

    @IBAction func submitStrengthWeakness(_ sender: Any) {
        resignResponder()
        
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/character"
        
        let paramToSend = "kelebihan=" + kelebihan.text! + "&kekurangan=" + kekurangan.text!
        
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
