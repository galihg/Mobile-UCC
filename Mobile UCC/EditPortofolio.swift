//
//  Portofolio.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditPortofolio: BaseViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var _title: UITextField!
    @IBOutlet weak var _yearStart: UITextField!
    @IBOutlet weak var _yearEnd: UITextField!
    @IBOutlet weak var _url: UITextField!
    
    @IBOutlet weak var deskripsi: UITextView!
    
    var passedData: String!
    var tgl_mulai = ""
    var tgl_selesai = ""
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (passedData != "-1") {
            self.title = "Edit Portofolio"
        } else {
            self.title = "Add Portofolio"
        }
        
        // Do any additional setup after loading the view.
        auth_check()
        
        _title.delegate = self
        _url.delegate = self
        _yearStart.delegate = self
        _yearEnd.delegate = self
        
        deskripsi.delegate = self
        deskripsi.layer.borderWidth = 1.0
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(EditPortofolio.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(EditPortofolio.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        datePicker.datePickerMode = .date
        //Add datePicker to textField
        _yearStart.inputView = datePicker
        _yearEnd.inputView = datePicker
        
        //Add toolbar to textField
        _yearStart.inputAccessoryView = toolbar
        _yearEnd.inputAccessoryView = toolbar
        
    }
    
    func auth_check() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    if (self.passedData != "-1") {
                        self.detailPortofolio()
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
                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                        NotificationCenter.default.post(name: .reload, object: nil)
                    }
                    
                }
            }
        }
    }
    
    func detailPortofolio() {
        let id_portofolio = passedData
        let url = "http://api.career.undip.ac.id/v1/jobseekers/detail_cv_part/portofolio?id_data=" + id_portofolio!
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let portDictionary = server_response["data"] as! [String:Any]
                    let id_portofolio = portDictionary["id_portofolio"] as? String
                    let id_member = portDictionary["id_member"] as? String
                    let judul = portDictionary["judul"] as? String
                    let tgl_mulai = portDictionary["tgl_mulai"] as? String ?? ""
                    let tgl_selesai = portDictionary["tgl_selesai"] as? String ?? ""
                    let url = portDictionary["url"] as? String ?? ""
                    let deskripsi = portDictionary["deskripsi"] as? String ?? ""
                    
                    self.tgl_mulai = tgl_mulai
                    self.tgl_selesai = tgl_selesai
                    
                    DispatchQueue.main.async {
                        HUD.hide()

                        self._title.text = judul
                        self.deskripsi.text = deskripsi
                        self._url.text = url
                        
                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateFromString : NSDate  = self.dateFormatter.date(from: tgl_mulai)! as NSDate
                        
                        self.dateFormatter.dateFormat = "dd MMM yyyy"
                        let datenew = self.dateFormatter.string(from: dateFromString as Date)
                        self._yearStart.text = datenew
                        
                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateFromString2 : NSDate  = self.dateFormatter.date(from: tgl_selesai)! as NSDate
                        
                        self.dateFormatter.dateFormat = "dd MMM yyyy"
                        let datenew2 = self.dateFormatter.string(from: dateFromString2 as Date)
                        self._yearEnd.text = datenew2
                        
                    }
                    
                }
            }
        }
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    @objc func donedatePicker(){
        //For date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if (activeTextField == _yearStart) {
            tgl_mulai = dateFormatter.string(from: datePicker.date)
        } else if (activeTextField == _yearEnd) {
            tgl_selesai = dateFormatter.string(from: datePicker.date)
        }
        
        //display time
        dateFormatter.dateFormat = " dd MMM yyyy"
        activeTextField.text = dateFormatter.string(from: datePicker.date)
        
        //dismiss date picker dialog
        self.view.endEditing(true)
        
        resignResponder()
        
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        resignFirstResponder()
    }
    
    func resignResponder() {
        _title.resignFirstResponder()
        _url.resignFirstResponder()
        _yearStart.resignFirstResponder()
        _yearEnd.resignFirstResponder()
        deskripsi.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.layoutIfNeeded()
        return true
    }
    
    @IBAction func savePortofolio(_ sender: Any) {
        
        resignResponder()
        HUD.show(.progress)
        
        if (passedData == "-1") {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/portofolio"
            
            let paramToSend = "tgl_mulai=" + tgl_mulai + "&tgl_selesai=" + tgl_selesai
            let paramToSend2 = "&judul=" + _title.text! + "&url=" + _url.text!
            let paramToSend3 = "&deskripsi=" + deskripsi.text!
            
            let paramFinal = paramToSend + paramToSend2 + paramToSend3
            
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
            let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/portofolio"
            
            let paramToSend = "tgl_mulai=" + tgl_mulai + "&tgl_selesai=" + tgl_selesai
            let paramToSend2 = "&judul=" + _title.text! + "&url=" + _url.text!
            let paramToSend3 = "&deskripsi=" + deskripsi.text! + "&id_data=" + passedData
            
            let paramFinal = paramToSend + paramToSend2 + paramToSend3
            
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
