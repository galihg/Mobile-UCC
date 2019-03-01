//
//  AwardsAndAchievements.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
class EditAwardsAndAchievements: BaseViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var _name: UITextField!
    @IBOutlet weak var _year: UITextField! {
        didSet {
            _year.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet weak var _appreciator: UITextField!
    
    @IBOutlet weak var deskripsi: UITextView!
    
    var passedData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (passedData[0] != "-1") {
            self.title = "Edit Award and Achievement"
        } else {
            self.title = "Add Award and Achievement"
        }
        // Do any additional setup after loading the view.
        auth_check()
        
        _name.delegate = self
        _year.delegate = self
        _appreciator.delegate = self

        deskripsi.delegate = self
        deskripsi.layer.borderWidth = 1.0
        
        if (passedData[0] != "-1") {
            _name.text = passedData[1]
            _year.text = passedData[2]
            _appreciator.text = passedData[3]
            deskripsi.text = passedData[4]
        }
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
        _name.resignFirstResponder()
        _year.resignFirstResponder()
        _appreciator.resignFirstResponder()
        deskripsi.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.layoutIfNeeded()
        
        return true
        
    }
    
    @objc func doneButtonTappedForMyNumericTextField() {
        print("Done");
        self.view.endEditing(true)
    }
    
    @IBAction func submitAward(_ sender: Any) {
        resignResponder()
        HUD.show(.progress)
        
        if (passedData[0] == "-1") {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/achievement"
            
            let paramToSend = "nama_prestasi=" + _name.text! + "&pemberi=" + _appreciator.text!
            let paramToSend2 = "&tahun=" + _year.text! + "&keterangan=" + deskripsi.text!
            
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
        } else {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/achievement"
            
            let paramToSend = "nama_prestasi=" + _name.text! + "&pemberi=" + _appreciator.text!
            let paramToSend2 = "&tahun=" + _year.text! + "&keterangan=" + deskripsi.text! + "&id_data=" + passedData[0]
            
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
    }
    
}
