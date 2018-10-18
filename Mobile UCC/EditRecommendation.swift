//
//  Recommendation.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditRecommendation: BaseViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var _name: UITextField!
    @IBOutlet weak var _phone: UITextField! {
        didSet {
            _phone.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet weak var _position: UITextField!
    
    @IBOutlet weak var address: UITextView!
    
    var passedData: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (passedData != "-1") {
            self.title = "Edit Recommendation"
        } else {
            self.title = "Add Recommendation"
        }
        // Do any additional setup after loading the view.
        auth_check()
        
        _name.delegate = self
        _phone.delegate = self
        _position.delegate = self
        
        address.delegate = self
        address.layer.borderWidth = 1.0
        
    }
    
    func auth_check() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    if (self.passedData != "-1") {
                        self.detailRecommendation()
                    } else {
                        DispatchQueue.main.async {
                            HUD.hide()
                        }
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
    
    func detailRecommendation() {
        let id_rekomendasi = passedData
        let url = "http://api.career.undip.ac.id/v1/jobseekers/detail_cv_part/recommendation?id_data=" + id_rekomendasi!
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let recDictionary = server_response["data"] as! [String:Any]
                    let id_rek = recDictionary["id_rek"] as? String
                    let id_member = recDictionary["id_member"] as? String
                    let nama_rek = recDictionary["nama_rek"] as? String
                    let alamat = recDictionary["alamat"] as? String
                    let posisi = recDictionary["posisi"] as? String ?? ""
                    let no_tlp = recDictionary["no_tlp"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        HUD.hide()
                        
                        self._name.text = nama_rek
                        self.address.text = alamat
                        self._position.text = posisi
                        self._phone.text = no_tlp
                        
                    }
                    
                }
            }
        }
    }
    
    func resignResponder() {
        _name.resignFirstResponder()
        _phone.resignFirstResponder()
        _position.resignFirstResponder()
        address.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        self.view.layoutIfNeeded()
        
        return true
        
    }
    
    func doneButtonTappedForMyNumericTextField() {
        print("Done");
        self.view.endEditing(true)
    }
    
    @IBAction func submitAward(_ sender: Any) {
        resignResponder()
        HUD.show(.progress)
        
        if (passedData == "-1") {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/recommendation"
            
            let paramToSend = "nama_rek=" + _name.text! + "&posisi=" + _position.text!
            let paramToSend2 = "&no_tlp=" + _phone.text! + "&alamat=" + address.text!
            
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
            let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/recommendation"
            
            let paramToSend = "nama_rek=" + _name.text! + "&posisi=" + _position.text!
            let paramToSend2 = "&no_tlp=" + _phone.text! + "&alamat=" + address.text! + "&id_data=" + passedData
            
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
