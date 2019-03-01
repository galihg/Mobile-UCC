//
//  LanguageSkills.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditLanguageSkills: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var languageTable: UITableView!
    @IBOutlet weak var skillTable: UITableView!
    
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var skillBtn: UIButton!
    
    var passedData: String!
    var language = ""
    var skill = ""
    
    var bahasaAsing = ["1": "Jepang", "2": "Perancis", "3": "Mandarin", "4": "Korea", "5": "Belanda", "6": "Inggris", "7": "Jerman"]
    var kemampuan = ["1": "Pemula", "2": "Menengah", "3": "Mahir"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (passedData != "-1") {
            self.title = "Edit Language Skill"
        } else {
            self.title = "Add Language Skill"
        }
        
        languageTable.isHidden = true
        skillTable.isHidden = true
        
        setTable(languageTable)
        setTable(skillTable)
        
        auth_check()
    }
    
    func auth_check() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    
                    if (self.passedData != "-1") {
                        
                        self.getDetailLanguage()
                        
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
    
    func getDetailLanguage() {
        
        let id_language = passedData
        let url = "http://api.career.undip.ac.id/v1/jobseekers/detail_cv_part/foreignlanguage?id_bahasa_asing=" + id_language!
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let languageDictionary = server_response["data"] as! [String:Any]
                    let id_bhs = languageDictionary["id_bhs"] as? String
                    let id_member = languageDictionary["id_member"] as? String
                    let bahasa = languageDictionary["bahasa"] as? String
                    let kemampuan = languageDictionary["kemampuan"] as? String
                    
                    DispatchQueue.main.async {
                        self.languageBtn.setTitle(self.filterDictionary(parameter: bahasa!, tipe: "bahasa", status: "nama"), for: [])
                        self.skillBtn.setTitle(self.filterDictionary(parameter: kemampuan!, tipe: "skill", status: "nama"), for: [])
                        HUD.hide()
                    }
                }
            }
        }
    }
    
    func filterDictionary(parameter: String, tipe: String, status: String) -> String {
        var filteredParameter: String!
        let languages = bahasaAsing
        let skills = kemampuan
        
        if (tipe == "bahasa" && status == "nama") {
            
            for(kode, nama) in languages {
                if (kode == parameter) {
                    filteredParameter = nama
                    break
                } else {
                    filteredParameter = "- Choose Language -"
                }
            }
        } else if (tipe == "skill" && status == "nama") {
            
            for(kode, nama) in skills {
                if (kode == parameter){
                    filteredParameter = nama
                    break
                } else {
                    filteredParameter = "- Choose Skill -"
                }
            }
        } else if (tipe == "bahasa" && status == "id") {
            
            for(kode, nama) in languages {
                if (nama == parameter){
                    filteredParameter = kode
                    break
                } else {
                    filteredParameter = ""
                }
            }
        } else {
            
            for(kode, nama) in skills {
                if (nama == parameter){
                    filteredParameter = kode
                    break
                } else {
                    filteredParameter = ""
                }
            }
        }
        
        return filteredParameter
    }
    
    func filterArray(_ setOfDictionary: Dictionary<String, String>) -> [String] {
        var filteredArray = [String]()
        for (kode, nama) in setOfDictionary {
            filteredArray.append(nama)
        }
        return filteredArray
    }
    
    func setTable(_ table:UITableView) {
        table.estimatedRowHeight = table.rowHeight
        table.rowHeight = UITableView.automaticDimension
        table.dataSource = self
        table.delegate = self
        table.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == languageTable) {
            return bahasaAsing.count
        } else {
            return kemampuan.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == languageTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
            
            cell.textLabel?.text = filterArray(bahasaAsing)[indexPath.row]
            cell.textLabel?.sizeToFit()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath)
            
            cell.textLabel?.text = filterArray(kemampuan)[indexPath.row]
            cell.textLabel?.sizeToFit()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == languageTable) {
            let language = filterArray(bahasaAsing)[indexPath.row]
            let languageCode = filterDictionary(parameter: language, tipe: "bahasa", status: "id")
            let index = indexPath
            let tipe = "bahasa"
            
            parsingPlace(languageTable, language, languageCode, languageBtn, index, tipe)
        } else {
            let skill = filterArray(kemampuan)[indexPath.row]
            let skillCode = filterDictionary(parameter: skill, tipe: "skill", status: "id")
            let index = indexPath
            let tipe = "skill"
            
            parsingPlace(skillTable, skill, skillCode, skillBtn, index, tipe)
        }
    }
    
    func parsingPlace(_ tableView: UITableView, _ name: String, _ id: String, _ button: UIButton, _ indexPath:
        IndexPath, _ tipe: String) {
        
        if (tipe == "bahasa") {
            language = id
        } else {
            skill = id
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        button.setTitle(name, for: [])
    }
    
    @IBAction func chooseLanguage(_ sender: Any) {
        if (languageTable.isHidden == true) {
            languageTable.isHidden = false
            skillTable.isHidden = true
        } else {
            languageTable.isHidden = true
        }
    }
    
    @IBAction func chooseSkill(_ sender: Any) {
        if (skillTable.isHidden == true) {
            skillTable.isHidden = false
            languageTable.isHidden = true
        } else {
            skillTable.isHidden = true
        }
    }
    
    @IBAction func saveLanguage(_ sender: Any) {
        HUD.show(.progress)
        
        if (passedData == "-1") {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/foreignlanguage"
            
            let paramToSend = "bahasa=" + language + "&kemampuan=" + skill
            
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
            
        } else {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/foreignlanguage"
            
            let paramToSend = "bahasa=" + language + "&kemampuan=" + skill + "&id_bahasa_asing=" + passedData
            
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
    
    


}
