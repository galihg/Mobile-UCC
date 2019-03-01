//
//  OrganizationExperience.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditOrganizationExperience: BaseViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var _organizationName: UITextField!
    @IBOutlet weak var _positionName: UITextField!
    @IBOutlet weak var _yearStart: UITextField!
    @IBOutlet weak var _yearEnd: UITextField!
    
    @IBOutlet weak var deskripsi: UITextView!
    
    @IBOutlet weak var activeBtn: UIButton!
    
    @IBOutlet weak var yearEnd: UILabel!
    
    @IBOutlet weak var submitTop: NSLayoutConstraint!
    
    var passedData: String!
    var active = "0"
    var tgl_mulai = ""
    var tgl_selesai = ""
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (passedData != "-1") {
            self.title = "Edit Organization Experience"
        } else {
            self.title = "Add Organization Experience"
        }
        // Do any additional setup after loading the view.
        
        setConstraint()
        auth_check()
        
        _organizationName.delegate = self
        _positionName.delegate = self
        _yearStart.delegate = self
        _yearEnd.delegate = self
        
        deskripsi.delegate = self
        deskripsi.layer.borderWidth = 1.0
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(EditOrganizationExperience.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(EditOrganizationExperience.cancelDatePicker))
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
                        self.detailOrganization()
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
    
    func detailOrganization() {
        let id_organisasi = passedData
        let url = "http://api.career.undip.ac.id/v1/jobseekers/detail_cv_part/organization?id_data=" + id_organisasi!
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let orgDictionary = server_response["data"] as! [String:Any]
                    let id_org = orgDictionary["id_org"] as? String
                    let id_member = orgDictionary["id_member"] as? String
                    let nama_org = orgDictionary["nama_org"] as? String
                    let tgl_mulai = orgDictionary["tgl_masuk"] as? String ?? ""
                    let tgl_keluar = orgDictionary["tgl_keluar"] as? String ?? ""
                    let posisi = orgDictionary["posisi"] as? String ?? ""
                    let deskripsi = orgDictionary["deskripsi"] as? String ?? ""
                    let aktif = orgDictionary["aktif"] as? String ?? ""
         
                    self.tgl_mulai = tgl_mulai
                    self.tgl_selesai = tgl_keluar
                    self.active = aktif
                    
                    if (self.active == "1") {
                        DispatchQueue.main.async {
                            self.activeBtn.setImage(UIImage(named: "checked box.png")!, for: UIControl.State.normal)
                            self.yearEnd.isHidden = true
                            self._yearEnd.isHidden = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.activeBtn.setImage(UIImage(named: "unchecked box.png")!, for: UIControl.State.normal)
                            
                            self.dateFormatter.dateFormat = "yyyy-MM-dd"
                            let dateFromString2 : NSDate  = self.dateFormatter.date(from: tgl_keluar)! as NSDate
                            
                            self.dateFormatter.dateFormat = "dd MMM yyyy"
                            let datenew2 = self.dateFormatter.string(from: dateFromString2 as Date)
                            self._yearEnd.text = datenew2
                        }
                    }
                    
                    DispatchQueue.main.async {
                        HUD.hide()
                        self.setConstraint()
                        
                        self._organizationName.text = nama_org
                        self.deskripsi.text = deskripsi
                        self._positionName.text = posisi

                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateFromString : NSDate  = self.dateFormatter.date(from: tgl_mulai)! as NSDate
                        
                        self.dateFormatter.dateFormat = "dd MMM yyyy"
                        let datenew = self.dateFormatter.string(from: dateFromString as Date)
                        self._yearStart.text = datenew
                        
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
        
        print(activeTextField)
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
        _organizationName.resignFirstResponder()
        _positionName.resignFirstResponder()
        _yearStart.resignFirstResponder()
        _yearEnd.resignFirstResponder()
        deskripsi.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.layoutIfNeeded()
        
        return true
        
    }
    
    func setConstraint() {
        let distance = _yearEnd.frame.size.height + 8 + yearEnd.frame.size.height + 8
        
        if (active == "1"){
            UIView.animate(withDuration: 0.25, animations: {
                self.submitTop.constant = 16
                
                self.yearEnd.isHidden = true
                self._yearEnd.isHidden = true
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.submitTop.constant = distance + self.submitTop.constant
                
                self.yearEnd.isHidden = false
                self._yearEnd.isHidden = false
            })
        }
        
    }

    @IBAction func activeSet(_ sender: Any) {
        if (active == "0") {
            active = "1"
            activeBtn.setImage(UIImage(named: "checked box.png")!, for: UIControl.State.normal)
            tgl_selesai = ""
            setConstraint()
        }
        else if (active == "1"){
            active = "0"
            activeBtn.setImage(UIImage(named: "unchecked box.png")!, for: UIControl.State.normal)
            setConstraint()
        }
    }
    
    @IBAction func submitOrganization(_ sender: Any) {
        
        resignResponder()
        HUD.show(.progress)
        
        if (passedData == "-1") {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/organization"
            
            let paramToSend = "tgl_masuk=" + tgl_mulai + "&tgl_keluar=" + tgl_selesai
            let paramToSend2 = "&nama_org=" + _organizationName.text! + "&posisi=" + _positionName.text!
            let paramToSend3 = "&deskripsi=" + deskripsi.text!
            let paramToSend4 = "&tgl_keluar=" + tgl_selesai + "&aktif=" + active
            
            let paramFinal = paramToSend + paramToSend2 + paramToSend3 + paramToSend4
            
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
            let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/organization"
            
            let paramToSend = "id_data=" + passedData + "&tgl_masuk=" + tgl_mulai + "&tgl_keluar=" + tgl_selesai
            let paramToSend2 = "&nama_org=" + _organizationName.text! + "&posisi=" + _positionName.text!
            let paramToSend3 = "&aktif=" + active + "&deskripsi=" + deskripsi.text!
            
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
