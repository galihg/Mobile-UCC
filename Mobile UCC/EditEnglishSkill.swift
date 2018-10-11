//
//  KemampuanBahasaInggris.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditEnglishSkill: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    @IBOutlet weak var toeflYearTable: UITableView!
    @IBOutlet weak var toeflTypeTable: UITableView!
    @IBOutlet weak var ieltsYearTable: UITableView!
    @IBOutlet weak var toeicYearTable: UITableView!
    
    @IBOutlet weak var toeflTypeBtn: UIButton!
    @IBOutlet weak var toeflYearBtn: UIButton!
    @IBOutlet weak var ieltsYearBtn: UIButton!
    @IBOutlet weak var toeicYearBtn: UIButton!
    
    @IBOutlet weak var _toeflScore: UITextField! {
        didSet {
            _toeflScore.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet weak var _ieltsScore: UITextField! {
        didSet {
            _ieltsScore.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet weak var _toeicScore: UITextField! {
        didSet {
            _toeicScore.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    
    var passedData = [String]()
    var years = ["2018", "2017", "2016", "2015", "2014"]
    var toeflTypes = ["1": "PBT (Paper-Based Test)", "2": "CBT (Computer-Based Test)", "3": "iBT (Internet-Based Test)"]
    
    var toeflType = "0"
    var toeflScore = "0"
    var toeflYear = "0"
    var ieltsScore = "0"
    var ieltsYear = "0"
    var toeicScore = "0"
    var toeicYear = "0"
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var bottomConstraintConstant: CGFloat = 52.0
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Kemampuan Bahasa Inggris"
        // Do any additional setup after loading the view.
        
        setTable(toeflTypeTable)
        setTable(toeflYearTable)
        setTable(ieltsYearTable)
        setTable(toeicYearTable)
        
        toeflTypeTable.isHidden = true
        toeflYearTable.isHidden = true
        ieltsYearTable.isHidden = true
        toeicYearTable.isHidden = true
        
        _toeflScore.delegate = self
        _ieltsScore.delegate = self
        _toeicScore.delegate = self
        
        if (passedData[0] == "(empty)") {
            toeflTypeBtn.setTitle("- Choose Type -", for: [])
        } else {
            toeflTypeBtn.setTitle(passedData[0], for: [])
            toeflType = filterCode(passedData[0])
        }
        
        testEmptyScore(_toeflScore, passedData[1], &toeflScore)
        testEmptyYear(toeflYearBtn, passedData[2], &toeflYear)
        testEmptyScore(_ieltsScore, passedData[3], &ieltsScore)
        testEmptyYear(ieltsYearBtn, passedData[4], &ieltsYear)
        testEmptyScore(_toeicScore, passedData[5], &toeicScore)
        testEmptyYear(toeicYearBtn, passedData[6], &toeicYear)
       
        // Listen for the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func testEmptyYear(_ button: UIButton, _ year: String, _ parameter: inout String) {
        if (year == "(empty)") {
            button.setTitle("- Choose Year -", for: [])
        } else {
            button.setTitle(year, for: [])
            parameter = year
        }
    }
    
    func testEmptyScore(_ textField: UITextField, _ score: String, _ parameter: inout String) {
        if (score == "(empty)") {
            textField.text = ""
        } else {
            textField.text = score
            parameter = score
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
                    }
                    
                }
            }
        }
    }
    
    func filterType(_ types: Dictionary<String, String>) -> [String] {
        var filteredArray = [String]()
        
        for (kode, nama) in types {
            filteredArray.append(nama)
        }
        
        return filteredArray
    }
    
    func filterCode(_ name: String) -> String {
        var filteredCode: String!
        let types = toeflTypes
        
        for (kode,nama) in types {
            if (name == nama) {
                filteredCode = kode
                break
            }
        }
        
        return filteredCode
    }
    
    func setTable(_ tableView: UITableView) {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == toeflTypeTable) {
            return toeflTypes.count
        } else {
            return years.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == toeflTypeTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toeflTypeCell", for: indexPath)
            
            cell.textLabel?.text = filterType(toeflTypes)[indexPath.row]
            cell.textLabel?.sizeToFit()
            
            return cell
        } else if (tableView == toeflYearTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toeflYearCell", for: indexPath)
            
            cell.textLabel?.text = years[indexPath.row]
            cell.textLabel?.sizeToFit()
            
            return cell
        } else if (tableView == ieltsYearTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ieltsYearCell", for: indexPath)
            
            cell.textLabel?.text = years[indexPath.row]
            cell.textLabel?.sizeToFit()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toeicYearCell", for: indexPath)
            
            cell.textLabel?.text = years[indexPath.row]
            cell.textLabel?.sizeToFit()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == toeflTypeTable) {
            let type = filterType(toeflTypes)[indexPath.row]
            let typeCode = filterCode(type)
            let index = indexPath
            
            parsingPlace(toeflTypeTable, type, typeCode, toeflTypeBtn, index, "toefltype")
            
        } else if (tableView == toeflYearTable) {
            let year = years[indexPath.row]
            let index = indexPath
            
            parsingPlace(toeflYearTable, year, "", toeflYearBtn, index, "toeflyear")
            
        } else if (tableView == ieltsYearTable) {
            let year = years[indexPath.row]
            let index = indexPath
            
            parsingPlace(ieltsYearTable, year, "", ieltsYearBtn, index, "ieltsyear")
        } else {
            let year = years[indexPath.row]
            let index = indexPath
            
            parsingPlace(toeicYearTable, year, "", toeicYearBtn, index, "toeicyear")
        }
    }
    
    func parsingPlace(_ tableView: UITableView, _ name: String, _ id: String, _ button: UIButton, _ indexPath:
        IndexPath, _ tipe: String) {
        
        if (tipe == "toefltype") {
            toeflType = id
        } else if (tipe == "toeflyear") {
            toeflYear = name
        } else if (tipe == "ieltsyear") {
            ieltsYear = name
        } else if (tipe == "toeicyear") {
            toeicYear = name
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        button.setTitle(name, for: [])
    }
    
    func resignResponder() {
        _toeicScore.resignFirstResponder()
        _toeflScore.resignFirstResponder()
        _ieltsScore.resignFirstResponder()
    }

    @IBAction func deleteValue(_ sender: UIButton) {
        if (sender.tag == 1) {
            toeflTypeBtn.setTitle("- Choose Type -", for: [])
            toeflYearBtn.setTitle("- Choose Year -", for: [])
            _toeflScore.text = ""
            toeflScore = "0"
            toeflYear = "0"
        } else if (sender.tag == 2) {
            ieltsYearBtn.setTitle("- Choose Year -", for: [])
            _ieltsScore.text = ""
            ieltsYear = "0"
            ieltsScore = "0"
        } else {
            toeicYearBtn.setTitle("- Choose Year -", for: [])
            _toeicScore.text = ""
            toeicScore = "0"
            toeicYear = "0"
        }
    }
    
    @IBAction func chooseTOEFLType(_ sender: Any) {
        if (toeflTypeTable.isHidden == true) {
            toeflTypeTable.isHidden = false
            toeflYearTable.isHidden = true
            ieltsYearTable.isHidden = true
            toeicYearTable.isHidden = true
        } else {
            toeflTypeTable.isHidden = true
        }
    }
    
    @IBAction func chooseTOEFLYear(_ sender: Any) {
        if (toeflYearTable.isHidden == true) {
            toeflTypeTable.isHidden = true
            toeflYearTable.isHidden = false
            ieltsYearTable.isHidden = true
            toeicYearTable.isHidden = true
        } else {
            toeflYearTable.isHidden = true
        }
    }
    
    @IBAction func chooseIELTSYear(_ sender: Any) {
        if (ieltsYearTable.isHidden == true) {
            toeflTypeTable.isHidden = true
            toeflYearTable.isHidden = true
            ieltsYearTable.isHidden = false
            toeicYearTable.isHidden = true
        } else {
            ieltsYearTable.isHidden = true
        }
    }
    
    @IBAction func chooseTOEICYear(_ sender: Any) {
        if (toeicYearTable.isHidden == true) {
            toeflTypeTable.isHidden = true
            toeflYearTable.isHidden = true
            ieltsYearTable.isHidden = true
            toeicYearTable.isHidden = false
        } else {
            toeflYearTable.isHidden = false
        }
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func doneButtonTappedForMyNumericTextField() {
        print("Done");
        resignResponder()
        
        if (activeTextField == _toeflScore) {
            toeflScore = _toeflScore.text!
        } else if (activeTextField == _ieltsScore) {
            ieltsScore = _ieltsScore.text!
        } else {
            toeicScore = _toeicScore.text!
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.bottomConstraint.constant = self.bottomConstraintConstant
            self.view.layoutIfNeeded()
            
        })
    }
    
    func keyboardWillShow(notification:NSNotification) {
        
        if let info = notification.userInfo {
            
            let rect:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.bottomConstraint.constant = 263
                self.view.layoutIfNeeded()
                
            })
            
        }
        
    }
    
    @IBAction func saveEnglish(_ sender: Any) {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/english"
        
        let paramToSend = "tipe_toefl=" + toeflType + "&nilai_toefl=" + toeflScore
        let paramToSend2 = "&thn_toefl=" + toeflYear + "&nilai_ielts=" + ieltsScore
        let paramToSend3 = "&thn_ielts=" + ieltsYear + "&nilai_toeic=" + toeicScore
        let paramToSend4 = "&thn_toeic=" + toeicYear
        
        let paramFinal = paramToSend + paramToSend2 + paramToSend3 + paramToSend4
        
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
