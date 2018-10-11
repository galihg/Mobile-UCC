//
//  Experience.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditWorkExperience: BaseViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var resignDateLbl: UILabel!
    
    @IBOutlet weak var _entryDate: UITextField!
    @IBOutlet weak var _resignDate: UITextField!
    @IBOutlet weak var _companyName: UITextField!
    @IBOutlet weak var _position: UITextField!
    @IBOutlet weak var _lastSalary: UITextField!
    
    @IBOutlet weak var activeBtn: UIButton!
    @IBOutlet weak var industryBtn: UIButton!
    @IBOutlet weak var companyScaleBtn: UIButton!
    @IBOutlet weak var positionCategoryBtn: UIButton!
    @IBOutlet weak var jobTypeBtn: UIButton!
    @IBOutlet weak var levelBtn: UIButton!
    
    @IBOutlet weak var deskripsi: UITextView!
    
    @IBOutlet weak var industryTable: UITableView!
    @IBOutlet weak var positionCategoryTable: UITableView!
    @IBOutlet weak var companyScaleTable: UITableView!
    @IBOutlet weak var jobTypeTable: UITableView!
    @IBOutlet weak var levelTable: UITableView!
    
    @IBOutlet weak var companyTop: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var bottomConstraintConstant :  CGFloat = 32.0
    var active = "0"
    var passedData: String!
    var tgl_masuk: String = ""
    var tgl_keluar: String = ""
    var industri: String = ""
    var positionCategory: String = ""
    var type: String = ""
    var tingkatan: String = ""
    var skala: String = ""
    
    var companyScaleArray = [CompanyScale]()
    var jobTypeArray = [JobType]()
    var levelArray = [Level]()
    
    var industries = [Industri]()
    var kategoriPosisi = [KategoriPosisi]()
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (passedData != "-1") {
            self.title = "Edit Work Experience"
        } else {
            self.title = "Add Work Experience"
        }
        
        setConstraint()
        industryTable.isHidden = true
        positionCategoryTable.isHidden = true
        companyScaleTable.isHidden = true
        jobTypeTable.isHidden = true
        levelTable.isHidden = true
        
        deskripsi.layer.borderWidth = 1.0
        
        _entryDate.delegate = self
        _resignDate.delegate = self
        
        setTable(industryTable)
        setTable(positionCategoryTable)
        setTable(companyScaleTable)
        setTable(jobTypeTable)
        setTable(levelTable)
        
        auth_check()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditWorkExperience.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditWorkExperience.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        datePicker.datePickerMode = .date
        
        //Add datePicker to textField
        _entryDate.inputView = datePicker
        _resignDate.inputView = datePicker
        
        //Add toolbar to textField
        _entryDate.inputAccessoryView = toolbar
        _resignDate.inputAccessoryView = toolbar
        
        // Listen for the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func auth_check() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    
                    self.getIndustry()
                    self.getPositionCategory()
                    self.getExpOptions()
                    
                    if (self.passedData != "-1") {
                        
                        self.getDetailExperience()
                        
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
    
    func setConstraint() {
        let distance = resignDateLbl.frame.size.height + 8 + _resignDate.frame.size.height + 20
        
        if (active == "1"){
            UIView.animate(withDuration: 0.25, animations: {
                self.companyTop.constant = 8
                
                self.resignDateLbl.isHidden = true
                self._resignDate.isHidden = true
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.companyTop.constant = distance
                
                self.resignDateLbl.isHidden = false
                self._resignDate.isHidden = false
            })
        }
        
    }
    
    func getExpOptions() {
        
        companyScaleArray = []
        jobTypeArray = []
        levelArray = []
        
        let url = "http://api.career.undip.ac.id/v1/others/exp_options"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let dataDictionaries = server_response["data"] as! [String:Any]
                    
                    let scaleDictionaries = dataDictionaries["employer_scales"] as! [String:Any]
                    let levelDictionaries = dataDictionaries["exp_levels"] as! [String:Any]
                    let typeDictionaries = dataDictionaries["exp_types"] as! [String:Any]
                    
                    
                    for (id,deskripsi) in scaleDictionaries {
                        self.companyScaleArray.append(CompanyScale(id_skala: id, deskripsi: deskripsi as! String))
                    }
                    
                    for (id,deskripsi) in levelDictionaries {
                        self.levelArray.append(Level(id_level: id, deskripsi: deskripsi as! String))
                    }
                    
                    for (id,deskripsi) in typeDictionaries {
                        self.jobTypeArray.append(JobType(id_tipe: id, deskripsi: deskripsi as! String))
                    }

                    DispatchQueue.main.async {
                        self.companyScaleTable.reloadData()
                        self.jobTypeTable.reloadData()
                        self.levelTable.reloadData()
                    }
                    
                }
            }
        }
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func donedatePicker(){
        //For date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if (activeTextField == _entryDate) {
            tgl_masuk = dateFormatter.string(from: datePicker.date)
        } else if (activeTextField == _resignDate) {
            tgl_keluar = dateFormatter.string(from: datePicker.date)
        }
       
        print(activeTextField)
        //display time
        dateFormatter.dateFormat = " dd MMM yyyy"
        activeTextField.text = dateFormatter.string(from: datePicker.date)
        
        //dismiss date picker dialog
        self.view.endEditing(true)
        
        resignResponder()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.bottomConstraint.constant = self.bottomConstraintConstant
            self.view.layoutIfNeeded()
            
        })
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        
        resignResponder()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.bottomConstraint.constant = self.bottomConstraintConstant
            self.view.layoutIfNeeded()
        })
    }
    
    func getIndustry() {
        
        industries = []
        
        let url = "https://api.career.undip.ac.id/v1/others/industries"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let industryDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for industryDictionary in industryDictionaries {
                        let id_bidang = industryDictionary["id_bidang"] as? String
                        let deskripsi = industryDictionary["deskripsi"] as? String
                        
                        self.industries.append(Industri(id_bidang:id_bidang!, deskripsi: deskripsi!))
                    }
                    
                    DispatchQueue.main.async {
                        self.industryTable.reloadData()
                    }
                }
            }
        }
    }
    
    func getPositionCategory() {
        kategoriPosisi = []
        
        let url = "https://api.career.undip.ac.id/v1/others/category_position"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let categoryPositionDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for categoryPositionDictionary in categoryPositionDictionaries {
                        let id_kat_posisi = categoryPositionDictionary["id_kat_posisi"] as? String
                        let deskripsi = categoryPositionDictionary["deskripsi"] as? String
                        
                    self.kategoriPosisi.append(KategoriPosisi(id_kategori:id_kat_posisi!, deskripsi: deskripsi!))
                    }
                    
                    DispatchQueue.main.async {
                        self.positionCategoryTable.reloadData()
                    }
                }
            }
        }
    }
    
    func getDetailExperience() {
        
        let id_pekerjaan = passedData
        let url = "http://api.career.undip.ac.id/v1/jobseekers/detail_cv_part/work?id_pekerjaan=" + id_pekerjaan!
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let workDictionary = server_response["data"] as! [String:Any]
                    let id_pekerjaan = workDictionary["id_pekerjaan"] as? String
                    let id_member = workDictionary["id_member"] as? String
                    let tgl_masuk = workDictionary["tgl_masuk"] as? String ?? ""
                    let tgl_keluar = workDictionary["tgl_keluar"] as? String ?? ""
                    let perusahaan = workDictionary["perusahaan"] as? String ?? ""
                    let industri = workDictionary["industri"] as? String ?? ""
                    let skala = workDictionary["skala"] as? String ?? ""
                    let posisi = workDictionary["posisi"] as? String ?? ""
                    let kategori_posisi = workDictionary["kategori_posisi"] as? String ?? ""
                    let deskripsi = workDictionary["deskripsi"] as? String ?? ""
                    let tipe = workDictionary["tipe"] as? String ?? ""
                    let level = workDictionary["level"] as? String ?? ""
                    let gaji = workDictionary["gaji"] as? String ?? ""
                    let aktif = workDictionary["aktif"] as? String ?? ""
                    let industri_deskripsi = workDictionary["industri_deskripsi"] as? String ?? ""
                    let kategori_posisi_deskripsi = workDictionary["kategori_posisi_deskripsi"] as? String ?? ""
                    
                    self.tgl_masuk = tgl_masuk
                    self.tgl_keluar = tgl_keluar
                    self.active = aktif
                    self.industri = industri
                    self.positionCategory = kategori_posisi
                    self.type = tipe
                    self.tingkatan = level
                    self.skala = skala
                   
                    if (self.active == "1") {
                        DispatchQueue.main.async {
                           self.activeBtn.setImage(UIImage(named: "checked box.png")!, for: UIControlState.normal)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.activeBtn.setImage(UIImage(named: "unchecked box.png")!, for: UIControlState.normal)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        HUD.hide()
                        self.setConstraint()
                        
                        self._companyName.text = perusahaan
                        self.deskripsi.text = deskripsi
                        self._position.text = posisi
                        self._lastSalary.text = gaji
                        
                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateFromString : NSDate  = self.dateFormatter.date(from: tgl_masuk)! as NSDate
                        
                        self.dateFormatter.dateFormat = "dd MMM yyyy"
                        let datenew = self.dateFormatter.string(from: dateFromString as Date)
                        self._entryDate.text = datenew
                        
                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateFromString2 : NSDate  = self.dateFormatter.date(from: tgl_keluar)! as NSDate
                        
                        self.dateFormatter.dateFormat = "dd MMM yyyy"
                        let datenew2 = self.dateFormatter.string(from: dateFromString2 as Date)
                        self._resignDate.text = datenew2
                        
                        self.industryBtn.setTitle(industri_deskripsi, for:[])
                        self.positionCategoryBtn.setTitle(kategori_posisi_deskripsi, for: [])
                        
                    }
                    
                }
            }
        }
    }
    
    func setTable(_ table:UITableView) {
        table.estimatedRowHeight = table.rowHeight
        table.rowHeight = UITableViewAutomaticDimension
        table.dataSource = self
        table.delegate = self
        table.isHidden = true
    }
    
    @IBAction func activeSet(_ sender: Any) {
        if (active == "0") {
            active = "1"
            activeBtn.setImage(UIImage(named: "checked box.png")!, for: UIControlState.normal)
            tgl_keluar = ""
            setConstraint()
        }
        else if (active == "1"){
            active = "0"
            activeBtn.setImage(UIImage(named: "unchecked box.png")!, for: UIControlState.normal)
            setConstraint()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == industryTable) {
            return industries.count
        } else if (tableView == companyScaleTable) {
            return companyScaleArray.count
        } else if (tableView == positionCategoryTable) {
            return kategoriPosisi.count
        } else if (tableView == jobTypeTable) {
            return jobTypeArray.count
        } else {
            return levelArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == industryTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "industryCell", for: indexPath)
            let industri = self.industries[indexPath.row]
            
            cell.textLabel?.text = industri.deskripsi
            cell.textLabel?.sizeToFit()
            
            return cell
            
        } else if (tableView == companyScaleTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyScaleCell", for: indexPath)
            let companyScale = self.companyScaleArray[indexPath.row]
            
            cell.textLabel?.text = companyScale.deskripsi
            cell.textLabel?.sizeToFit()
            return cell
            
        } else if (tableView == positionCategoryTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCategoryCell", for: indexPath)
            let kategoriPosisi = self.kategoriPosisi[indexPath.row]
            
            cell.textLabel?.text = kategoriPosisi.deskripsi
            cell.textLabel?.sizeToFit()
            return cell
            
        } else if (tableView == jobTypeTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "jobTypeCell", for: indexPath)
            let jobType = self.jobTypeArray[indexPath.row]
            
            cell.textLabel?.text = jobType.deskripsi
            cell.textLabel?.sizeToFit()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "levelCell", for: indexPath)
            let level = self.levelArray[indexPath.row]
            
            cell.textLabel?.text = level.deskripsi
            cell.textLabel?.sizeToFit()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        if (tableView == industryTable) {
            
            let industry = self.industries[indexPath.row]
            let industryName = industry.deskripsi
            let industryId = industry.id_bidang
            let index = indexPath
            let tipe = "industry"
            
            parsingPlace(industryTable, industryName!, industryId!, industryBtn, index, tipe)
            
        } else if (tableView == companyScaleTable) {
            
            let scale = self.companyScaleArray[indexPath.row]
            let scaleName = scale.deskripsi
            let scaleId = scale.id_skala
            let index = indexPath
            let tipe = "scale"
            
            parsingPlace(companyScaleTable, scaleName!, scaleId!, companyScaleBtn, index, tipe)
            
        }  else if (tableView == positionCategoryTable) {
            
            let position = self.kategoriPosisi[indexPath.row]
            let positionName = position.deskripsi
            let positionId = position.id_kategori
            let index = indexPath
            let tipe = "position"
            
            parsingPlace(positionCategoryTable, positionName!, positionId!, positionCategoryBtn, index, tipe)
            
        } else if (tableView == jobTypeTable) {
            
            let type = self.jobTypeArray[indexPath.row]
            let typeName = type.deskripsi
            let typeId = type.id_tipe
            let index = indexPath
            let tipe = "type"
            
            parsingPlace(jobTypeTable, typeName!, typeId!, jobTypeBtn, index, tipe)
            
        } else {
            let level = self.levelArray[indexPath.row]
            let levelName = level.deskripsi
            let levelId = level.id_level
            let index = indexPath
            let tipe = "level"
            
            parsingPlace(levelTable, levelName!, levelId!, levelBtn, index, tipe)
            
        }
    }
    
    func parsingPlace(_ tableView: UITableView, _ name: String, _ id: String, _ button: UIButton, _ indexPath:
        IndexPath, _ tipe: String) {
        
        if (tipe == "industry") {
            industri = id
        } else if (tipe == "scale") {
            skala = id
        } else if (tipe == "position") {
            positionCategory = id
        } else if (tipe == "type") {
            type = id
        } else if (tipe == "level") {
            tingkatan = id
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        button.setTitle(name, for: [])
        
    }
    
    @IBAction func setIndustry(_ sender: Any) {
        if (industryTable.isHidden == true) {
            industryTable.isHidden = false
            companyScaleTable.isHidden = true
            positionCategoryTable.isHidden = true
            jobTypeTable.isHidden = true
            levelTable.isHidden = true
        } else {
            industryTable.isHidden = true
        }
    }
    
    @IBAction func setCompanyScale(_ sender: Any) {
        if (industryTable.isHidden == true) {
            industryTable.isHidden = true
            companyScaleTable.isHidden = false
            positionCategoryTable.isHidden = true
            jobTypeTable.isHidden = true
            levelTable.isHidden = true
        } else {
            companyScaleTable.isHidden = true
        }
    }
    
    @IBAction func setPosition(_ sender: Any) {
        if (positionCategoryTable.isHidden == true) {
            industryTable.isHidden = true
            companyScaleTable.isHidden = true
            positionCategoryTable.isHidden = false
            jobTypeTable.isHidden = true
            levelTable.isHidden = true
        } else {
            positionCategoryTable.isHidden = true
        }
    }
    
    @IBAction func setJobType(_ sender: Any) {
        if (industryTable.isHidden == true) {
            industryTable.isHidden = true
            companyScaleTable.isHidden = true
            positionCategoryTable.isHidden = true
            jobTypeTable.isHidden = false
            levelTable.isHidden = true
        } else {
            jobTypeTable.isHidden = true
        }
    }
    
    @IBAction func setLevel(_ sender: Any) {
        if (industryTable.isHidden == true) {
            industryTable.isHidden = true
            companyScaleTable.isHidden = true
            positionCategoryTable.isHidden = true
            jobTypeTable.isHidden = true
            levelTable.isHidden = false
        } else {
            levelTable.isHidden = true
        }
    }
    
    @IBAction func saveExperience(_ sender: Any) {
        resignResponder()
        HUD.show(.progress)
        
        if (passedData == "-1") {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/work"
            
            let paramToSend = "tgl_masuk=" + tgl_masuk + "&tgl_keluar=" + tgl_keluar
            let paramToSend2 = "&industri=" + industri + "&posisi=" + _position.text!
            let paramToSend3 = "&kategori_posisi=" + positionCategory + "&deskripsi=" + deskripsi.text!
            let paramToSend4 = "&level=" + tingkatan + "&gaji=" + _lastSalary.text!
            let paramToSend5 = "&perusahaan=" + _companyName.text! + "&aktif=" + active
            let paramToSend6 = "&tipe=" + type + "&skala=" + skala
            
            let paramFinal = paramToSend + paramToSend2 + paramToSend3 + paramToSend4 + paramToSend5 + paramToSend6
            
            NetworkService.parseJSONFromURL(url, "POST", parameter: paramFinal){ (server_response) in
                if let message = server_response["message"] as? String {
                    Alert.showMessage(title: "WARNING!", msg: message)
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                }
            }
        } else {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/work"
            
            let paramToSend = "id_pekerjaan=" + passedData + "&tgl_masuk=" + tgl_masuk + "&tgl_keluar=" + tgl_keluar
            let paramToSend2 = "&industri=" + industri + "&posisi=" + _position.text!
            let paramToSend3 = "&kategori_posisi=" + positionCategory + "&deskripsi=" + deskripsi.text!
            let paramToSend4 = "&level=" + tingkatan + "&gaji=" + _lastSalary.text!
            let paramToSend5 = "&perusahaan=" + _companyName.text! + "&aktif=" + active
            let paramToSend6 = "&tipe=" + type + "&skala=" + skala
            
            let paramFinal = paramToSend + paramToSend2 + paramToSend3 + paramToSend4 + paramToSend5 + paramToSend6
            
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
    
    func resignResponder() {
        _entryDate.resignFirstResponder()
        _resignDate.resignFirstResponder()
        _companyName.resignFirstResponder()
        _position.resignFirstResponder()
        _lastSalary.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignResponder()
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.bottomConstraint.constant = self.bottomConstraintConstant
            self.view.layoutIfNeeded()
            
        })
        return true
        
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
    

}
