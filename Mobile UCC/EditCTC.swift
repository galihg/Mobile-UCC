//
//  CTC.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditCTC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var _name: UITextField!
    @IBOutlet weak var _year: UITextField! {
        didSet {
            _year.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet weak var _organizer: UITextField!
    
    @IBOutlet weak var certificateBtn: UIButton!
    
    var passedData = [String]()
    var certificate = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (passedData[0] == "-1") {
            self.title = "Add Course / Training / Certification"
        } else {
            self.title = "Edit Course / Training / Certification"
            _name.text = passedData[1]
            _organizer.text = passedData[2]
            _year.text = passedData[4]
            certificate = passedData[3]
            
            if (certificate == "1") {
                certificateBtn.setImage(UIImage(named: "checked box.png")!, for: UIControlState.normal)
            } else {
                certificateBtn.setImage(UIImage(named: "unchecked box.png")!, for: UIControlState.normal)
            }
        }

        // Do any additional setup after loading the view.
        
        auth_check()
        
        _name.delegate = self
        _year.delegate = self
        _organizer.delegate = self
        
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
                    }
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignResponder()
        
        self.view.layoutIfNeeded()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.layoutIfNeeded()
        
        return true
        
    }
    
    func resignResponder() {
        _name.resignFirstResponder()
        _year.resignFirstResponder()
        _organizer.resignFirstResponder()
    }
    
    func doneButtonTappedForMyNumericTextField() {
        print("Done");
        self.view.endEditing(true)
    }
    
    @IBAction func certificateSet(_ sender: Any) {
        if (certificate == "0") {
            certificate = "1"
            certificateBtn.setImage(UIImage(named: "checked box.png")!, for: UIControlState.normal)
        }
        else if (certificate == "1"){
            certificate = "0"
            certificateBtn.setImage(UIImage(named: "unchecked box.png")!, for: UIControlState.normal)
        }
    }
    
    
    @IBAction func saveCTC(_ sender: Any) {
        resignResponder()
        HUD.show(.progress)
        
        if (passedData[0] == "-1") {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/courses"
            
            let paramToSend = "nama_kursus=" + _name.text! + "&penyelenggara=" + _organizer.text!
            let paramToSend2 = "&tahun=" + _year.text! + "&sertifikat=" + certificate
            
            let paramFinal = paramToSend + paramToSend2
            
            NetworkService.parseJSONFromURL(url, "POST", parameter: paramFinal){ (server_response) in
                if let message = server_response["message"] as? String {
                    Alert.showMessage(title: "WARNING!", msg: message)
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                }
            }
        } else {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/courses"
            
            let paramToSend = "nama_kursus=" + _name.text! + "&penyelenggara=" + _organizer.text!
            let paramToSend2 = "&tahun=" + _year.text! + "&sertifikat=" + certificate + "&id_data=" + passedData[0]
            
            let paramFinal = paramToSend + paramToSend2
            
            NetworkService.parseJSONFromURL(url, "POST", parameter: paramFinal){ (server_response) in
                if let message = server_response["message"] as? String {
                    Alert.showMessage(title: "WARNING!", msg: message)
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                }
            }
        }
        
    }
    



}
