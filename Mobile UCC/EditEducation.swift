//
//  EditEducation.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 02/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditEducation: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var btnDegree: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var _university: UITextField!
    @IBOutlet weak var _major: UITextField!
    @IBOutlet weak var _accreditation: UITextField!
    @IBOutlet weak var _submajor: UITextField!
    @IBOutlet weak var _thesis: UITextField!
    @IBOutlet weak var _gpaScore: UITextField!{
        didSet {
            _gpaScore.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet weak var _entryMonth: UITextField!
    @IBOutlet weak var graduateLabel: UILabel!
    @IBOutlet weak var _graduatedMonth: UITextField!
    
    @IBOutlet weak var universityTop: NSLayoutConstraint!
    
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var btnProvince: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var btnCity: UIButton!
    
    @IBOutlet weak var degreeTable: UITableView!
    @IBOutlet weak var countryTable: UITableView!
    @IBOutlet weak var provinceTable: UITableView!
    @IBOutlet weak var cityTable: UITableView!
    
    @IBOutlet weak var btnGraduate: UIButton!
    @IBOutlet weak var graduateTable: UITableView!
    
    var jenjang = ["03-SMA": "SMA/SMK Sederajat", "21-S1": "Strata I", "31-S2": "Strata II", "41-S3": "Strata III", "22-PR": "Profesi" , "11-D1": "Diploma I", "12-D2": "Diploma II", "13-D3": "Diploma III", "14-D4": "Diploma IV"]
    
    var bulan = ["01": "Jan", "02": "Feb", "03": "Mar", "04": "Apr", "05": "May", "06": "June", "07": "Jul", "08": "Aug", "09": "Sep", "10": "Okt", "11": "Nov", "12": "Dec"]
    
    var items = ["- Choose -", "Not Yet", "Graduated"]
    
    var isIndonesia: Bool? = true
    var passedData: String!
    var id_negara = ""
    var id_provinsi = ""
    var id_kota = ""
    var id_jenjang = ""
    var graduate_status = ""
    var bln_masuk = ""
    var thn_masuk = ""
    var bln_lulus = ""
    var thn_lulus = ""
    
    var provinsi = [Provinsi]()
    var kota = [Kota]()
    var negara = [Negara]()
    
    //Uidate picker
    let datePicker = UIDatePicker()
    
    let picker = DatePickerView()
    //fileprivate var pickerFromCode : CDatePickerViewEx = CDatePickerViewEx.init(frame: CGRect.zero)
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if (passedData != "-1") {
            self.title = "Edit Education"
        } else {
            self.title = "Add Education"
        }
        setTable(countryTable)
        setTable(degreeTable)
        setTable(provinceTable)
        setTable(cityTable)
        setTable(graduateTable)
        
        provinceLabel.isHidden = true
        btnProvince.isHidden = true
        cityLabel.isHidden = true
        btnCity.isHidden = true
        
        print(passedData)
        
        _university.delegate = self
        _major.delegate = self
        _accreditation.delegate = self
        _submajor.delegate = self
        _thesis.delegate = self
        _gpaScore.delegate = self
        _entryMonth.delegate = self
        _graduatedMonth.delegate = self
        
        _university.text = ""
        _major.text = ""
        _accreditation.text = ""
        _submajor.text = ""
        _thesis.text = ""
        _gpaScore.text = ""
        _entryMonth.text = ""
        _graduatedMonth.text = ""

        auth_check()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        

    }
    
    func auth_check() {
        
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    
                    DispatchQueue.main.async {
                        if (self.passedData == "-1") {
       
                            self.getCountries()
                            self.getProvinsi()
                            
                        } else {
   
                            HUD.show(.progress)
                            
                            self.getDetailEducation()
                            
                        }
                        
                }
                    
                } else if (status == "invalid-session"){
                    
                    let preferences = UserDefaults.standard
                    preferences.removeObject(forKey: "session")
                    
                    DispatchQueue.main.async {
                        self.openViewControllerBasedOnIdentifier("Home")
                        Alert.showMessage(title: "WARNING!", msg: "Sesi Login telah berakhir, silahkan login ulang")
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
    
    func resignResponder() {
        _university.resignFirstResponder()
        _graduatedMonth.resignFirstResponder()
        _entryMonth.resignFirstResponder()
        _gpaScore.resignFirstResponder()
        _major.resignFirstResponder()
        _thesis.resignFirstResponder()
        _submajor.resignFirstResponder()
        _accreditation.resignFirstResponder()
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeTextField = textField
        
        if (textField == _entryMonth || textField == _graduatedMonth ) {
            //show date picker
            showDatePicker(textField)
        }
    }
    
    func showDatePicker(_ textField: UITextField){
 
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditEducation.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditEducation.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        textField.inputAccessoryView = toolbar
        // add datepicker to textField
        textField.inputView = picker
        
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let month = formatter.string(from: picker.date)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: picker.date)
        let time = month + "/" + year
        var myStringArr = time.components(separatedBy: "/")
        
        if (self.activeTextField == _entryMonth){
            bln_masuk = myStringArr [0]
            thn_masuk = myStringArr [1]
            print (bln_masuk + thn_masuk)
        } else if (self.activeTextField == _graduatedMonth){
            bln_lulus = myStringArr [0]
            thn_lulus = myStringArr [1]
            print(bln_lulus + thn_lulus)
        }
        
        //display time
        formatter.dateFormat = " MMM yyyy"
        self.activeTextField.text = formatter.string(from: picker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
        
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog

        self.view.endEditing(true)
        self.view.layoutIfNeeded()
        
    }
    
    func setConstraint(_ id: String) {
        
        let distance = cityLabel.frame.size.height + 8 + btnCity.frame.size.height + 8
        let distance2 = provinceLabel.frame.size.height + 8 + btnProvince.frame.size.height + 8 + 16
        let distanceFinal = distance + distance2
        if (id != "ID") {
            
            isIndonesia = false
            UIView.animate(withDuration: 0.25, animations: {
                self.provinceLabel.isHidden = true
                self.btnProvince.isHidden = true
                self.cityLabel.isHidden = true
                self.btnCity.isHidden = true
                
                self.universityTop.constant = 8
                self.view.layoutIfNeeded()
                
            })
            
        }
        else {
            
            isIndonesia = true
            UIView.animate(withDuration: 0.25, animations: {
                self.provinceLabel.isHidden = false
                self.btnProvince.isHidden = false
                self.cityLabel.isHidden = false
                self.btnCity.isHidden = false
                
                self.universityTop.constant = 8 + distanceFinal
                self.view.layoutIfNeeded()
                
            })
        }
    }
    
    func getDetailEducation() {
        
        let id_pendidikan = passedData
        let url = "http://api.career.undip.ac.id/v1/jobseekers/detail_cv_part/education?id_pendidikan=" + id_pendidikan!
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let educationDictionaries = server_response["data"] as! NSDictionary
                    let id_pddk = educationDictionaries["id_pddk"] as? String
                    let id_member = educationDictionaries["id_member"] as? String ?? ""
                    let jenjang = educationDictionaries["jenjang"] as? String ?? ""
                    let negara = educationDictionaries["negara"] as? String ?? ""
                    let provinsi = educationDictionaries["provinsi"] as? String ?? ""
                    let kota = educationDictionaries["kota"] as? String ?? ""
                    let universitas = educationDictionaries["universitas"] as? String ?? ""
                    let jurusan = educationDictionaries["jurusan"] as? String ?? ""
                    let akreditasi = educationDictionaries["akreditasi"] as? String ?? ""
                    let konsentrasi = educationDictionaries["konsentrasi"] as? String ?? ""
                    let judul_ta = educationDictionaries["judul_ta"] as? String ?? ""
                    let ipk = educationDictionaries["ipk"] as? String ?? ""
                    let sudah_lulus = educationDictionaries["sudah_lulus"] as? String ?? ""
                    let bln_masuk = educationDictionaries["bln_masuk"] as? String ?? ""
                    let thn_masuk = educationDictionaries["thn_masuk"] as? String ?? ""
                    let bln_lulus = educationDictionaries["bln_lulus"] as? String ?? ""
                    let thn_lulus = educationDictionaries["thn_lulus"] as? String ?? ""
                    
                    self.id_provinsi = provinsi
                    self.id_kota = kota
                    self.passedData = id_pddk
                    self.id_negara = negara
                    self.id_jenjang = jenjang
                    self.graduate_status = sudah_lulus
                    self.bln_masuk = bln_masuk
                    self.thn_masuk = thn_masuk
                    self.bln_lulus = bln_lulus
                    self.thn_lulus = thn_lulus
                    
                    if (self.id_jenjang != "") {
                        self.getDegree()
                    }
                    if (self.id_negara != "") {
                        self.getCountries()
                    }
                    
                    if (self.id_provinsi != "") {
                        self.getProvinsi()
                        
                        if (self.id_kota != "") {
                            self.getKota(self.id_provinsi)
                        }
                    }
                    
                    if (self.graduate_status == "0") {
                        DispatchQueue.main.async {
                            self.btnGraduate.setTitle("Not Yet", for: [])
                            self.graduateLabel.text = "Estimated Graduating Month"
                        }
                    } else if (self.graduate_status == "1") {
                        DispatchQueue.main.async {
                            self.btnGraduate.setTitle("Graduated", for: [])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self._university.text = universitas
                        self._accreditation.text = akreditasi
                        self._major.text = jurusan
                        self._submajor.text = konsentrasi
                        self._thesis.text = judul_ta
                        self._gpaScore.text = ipk
                        self._entryMonth.text = self.filterPosisi(id: self.bln_masuk, tipe:"bulan") + " " + self.thn_masuk
                        self._graduatedMonth.text = self.filterPosisi(id: self.bln_lulus, tipe:"bulan") + " " + self.thn_lulus
                    }
                    
                }
            }
        }
    
    }
    
    func getDegree() {
        let namaJenjang = self.filterPosisi(id: self.id_jenjang, tipe: "jenjang")
        
        DispatchQueue.main.async {
            self.btnDegree.setTitle(namaJenjang, for: [])
        }
    }
    
    func getProvinsi() {
        
        provinsi = []
        
        let url = "http://api.career.undip.ac.id/v1/location/provinces/"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let provinceDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for provinceDictionary in provinceDictionaries {
                        
                        let id = provinceDictionary["id"] as? String
                        let nama = provinceDictionary["name"] as? String
                        
                        self.provinsi.append(Provinsi(id_provinsi: id!, nama_provinsi: nama!))
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.provinceTable.reloadData()
                        
                        if (self.passedData != "-1"){
                            
                            let namaProvinsi = self.filterPosisi(id: self.id_provinsi, tipe:"provinsi")
                            
                            print(namaProvinsi)
                            
                            self.btnProvince.setTitle(namaProvinsi, for: [])
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func getCountries() {
        
        negara = []
        
        let url = "http://api.career.undip.ac.id/v1/location/countries/"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let countryDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for countryDictionary in countryDictionaries {
                        
                        let id = countryDictionary["id"] as? String
                        let nama = countryDictionary["name"] as? String
                        
                        self.negara.append(Negara(id_negara: id!, nama_negara: nama!))
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.countryTable.reloadData()
                        
                        if (self.passedData != "-1") {
                            
                            let namaNegara = self.filterPosisi(id: self.id_negara, tipe: "negara")
                            
                            print(namaNegara)
                            
                            self.btnCountry.setTitle(namaNegara, for: [])
                            
                            if (self.id_negara) != nil {
                                self.setConstraint(self.id_negara)
                            } else {
                                print("error parsing json")
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func getKota(_ id: String) {
        kota = []
        
        let url = "http://api.career.undip.ac.id/v1/location/cities/" + id
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let cityDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for cityDictionary in cityDictionaries {
                        
                        let id = cityDictionary["id"] as? String
                        let nama = cityDictionary["name"] as? String
                        
                        self.kota.append(Kota(id_kota: id!, nama_kota: nama!))
                        print(self.kota)
                    }
                    
                    DispatchQueue.main.async {
                        HUD.hide()
                        self.cityTable.reloadData()
                        
                        let namaKota = self.filterPosisi(id: self.id_kota, tipe: "kota")
                        print(namaKota)
                        self.btnCity.setTitle(namaKota, for: [])
                     
                    }
                }
            }
        }
        
    }
    
    func filterPosisi(id: String, tipe: String) -> String{
        
        var filteredName: String!
        
        if (tipe == "negara") {
            let rawEntity = self.negara
            for entitas in rawEntity {
                
                if (id == entitas.id_negara){
                    filteredName = entitas.nama_negara
                    break
                } else {
                    filteredName = "- Choose Country -"
                }
            }
        } else if (tipe == "provinsi") {
            let rawEntity = self.provinsi
            
            for entitas in rawEntity {
                
                if (id == entitas.id_provinsi){
                    filteredName = entitas.nama_provinsi
                    break
                } else {
                    filteredName = "- Choose Province -"
                }
            }
           
        } else if (tipe == "kota") {
            let rawEntity = self.kota
            
            for entitas in rawEntity {
                
                if (id == entitas.id_kota){
                    filteredName = entitas.nama_kota
                    break
                } else {
                    filteredName = "- Choose City -"
                }
            }
        } else if (tipe == "jenjang"){
            let rawEntity = self.jenjang
            
            for (kode, degree) in rawEntity {
                if (kode == id){
                    filteredName = degree
                    break
                } else {
                    filteredName = "- Choose Degree -"
                }
            }
        } else if (tipe == "bulan") {
            let rawEntity = self.bulan
            
            for (kode, month) in rawEntity {
                if (kode == bln_masuk){
                    filteredName = month
                    break
                } else {
                    filteredName = ""
                }
            }
        }
        
        return filteredName
        
    }
    
    func filterDegree(_ degreeDictionary: Dictionary<String, String>) -> [String]{
       var filteredArray = [String]()
       for (kode, degree) in degreeDictionary {
            filteredArray.append(degree)
       }
       return filteredArray
    }
    
    func filterDegree2(_ degreeDictionary: Dictionary<String, String>, _ nama: String) -> String {
        var filteredString: String!
        for (kode, degree) in degreeDictionary {
           if (nama == degree) {
                filteredString = kode
            }
        }
        return filteredString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView == countryTable) {
            return negara.count
        } else if (tableView == provinceTable) {
            return provinsi.count
        } else if (tableView == cityTable) {
            return kota.count
        } else if (tableView == degreeTable) {
            return jenjang.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView == countryTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
            let negara = self.negara[indexPath.row]
            
            cell.textLabel?.text = negara.nama_negara
            cell.textLabel?.sizeToFit()
        
            return cell
            
        } else if (tableView == provinceTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell", for: indexPath)
            let provinsi = self.provinsi[indexPath.row]
            
            cell.textLabel?.text = provinsi.nama_provinsi
            cell.textLabel?.sizeToFit()
            return cell
            
        } else if (tableView == degreeTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "degreeCell", for: indexPath)

            cell.textLabel?.text = filterDegree(jenjang)[indexPath.row]
            cell.textLabel?.sizeToFit()
            return cell
            
        } else if (tableView == cityTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            let kota = self.kota[indexPath.row]
            
            cell.textLabel?.text = kota.nama_kota
            cell.textLabel?.sizeToFit()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "graduateCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row]
            cell.textLabel?.sizeToFit()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        if (tableView == countryTable) {
            
            let negara = self.negara[indexPath.row]
            let countryName = negara.nama_negara
            let countryId = negara.id_negara
            let index = indexPath
            let tipe = "negara"
            
            parsingPlace(countryTable, countryName!, countryId!, btnCountry, index, tipe)
            setConstraint(id_negara)
            
        } else if (tableView == provinceTable) {
            
            let provinsi = self.provinsi[indexPath.row]
            let provinceName = provinsi.nama_provinsi
            let provinceId = provinsi.id_provinsi
            let index = indexPath
            let tipe = "provinsi"
            
            parsingPlace(provinceTable, provinceName!, provinceId!, btnProvince, index, tipe)
            
        }  else if (tableView == cityTable) {
            
            let city = self.kota[indexPath.row]
            let cityName = city.nama_kota
            let cityId = city.id_kota
            let index = indexPath
            let tipe = "kota"
            
            parsingPlace(cityTable, cityName!, cityId!, btnCity, index, tipe)
            
        } else if (tableView == degreeTable) {
            let degree = filterDegree(jenjang)[indexPath.row]
            let degreeCode = filterDegree2(jenjang,degree)
            let index = indexPath
            let tipe = "jenjang"
            
            parsingPlace(degreeTable, degree, degreeCode, btnDegree , index, tipe)
            
        } else {
            let graduate = items[indexPath.row]
            let index = indexPath
            let tipe = "graduate"
            
            parsingPlace(graduateTable, graduate, "", btnGraduate, index, tipe)
            
        }
    }
    
    func parsingPlace(_ tableView: UITableView, _ name: String, _ id: String, _ button: UIButton, _ indexPath:
        IndexPath, _ tipe: String) {
        
        if (tipe == "negara") {
            id_negara = id
        } else if (tipe == "provinsi") {
            if ( id != id_provinsi ){
                id_provinsi = id
                id_kota = ""
                btnCity.setTitle("- Choose City -", for: [])
            }
        } else if (tipe == "kota") {
            id_kota = id
        } else if (tipe == "jenjang") {
            id_jenjang = id
        } else if (tipe == "graduate") {
            if (name == "Not Yet") {
                graduate_status = "0"
                graduateLabel.text = "Estimated Graduating Month"
            } else if (name == "Graduated"){
                graduate_status = "1"
                graduateLabel.text = "Graduated Month"
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        button.setTitle(name, for: [])
        
        
    }
    
    @IBAction func setDegree(_ sender: Any) {
        if (degreeTable.isHidden == true) {
            degreeTable.isHidden = false
        } else {
            degreeTable.isHidden = true
        }
        
    }
    
    @IBAction func setCountry(_ sender: Any) {
        
        if (countryTable.isHidden == true) {
            
            if (negara.count == 0){
                getCountries()
            }
            
            countryTable.isHidden = false
            degreeTable.isHidden = true
            provinceTable.isHidden = true
            cityTable.isHidden = true
        } else {
            countryTable.isHidden = true
        }
    }
    
    @IBAction func setProvince(_ sender: Any) {
        if (provinceTable.isHidden == true) {
            
            if (provinsi.count == 0){
                getProvinsi()
            }
            
            provinceTable.isHidden = false
            cityTable.isHidden = true
            countryTable.isHidden = true
            degreeTable.isHidden = true
        } else {
            provinceTable.isHidden = true
        }
    }
    
    @IBAction func setCity(_ sender: Any) {
        if (cityTable.isHidden == true) {
            cityTable.isHidden = false
            provinceTable.isHidden = true
            countryTable.isHidden = true
            degreeTable.isHidden = true
            
            getKota(id_provinsi)
        } else {
            cityTable.isHidden = true
        }
    }
    
    @IBAction func setGraduate(_ sender: Any) {
        if (graduateTable.isHidden == true) {
            graduateTable.isHidden = false
        } else {
            graduateTable.isHidden = true
        }
    }
    
    @IBAction func save_education(_ sender: Any) {
        resignResponder()
        if (self.passedData == "-1") {
            HUD.show(.progress)
            
            let url = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/education"
            
            let paramToSend = "jenjang=" + id_jenjang + "&negara=" + id_negara
            let paramToSend2 = "&provinsi=" + id_provinsi + "&kota=" + id_kota
            let paramToSend3 = "&universitas=" + _university.text! + "&jurusan=" + _major.text!
            let paramToSend4 = "&akreditasi=" + _accreditation.text! + "&konsentrasi=" + _submajor.text!
            let paramToSend5 = "&judul_ta=" + _thesis.text! + "&ipk=" + _gpaScore.text!
            let paramToSend6 = "&sudah_lulus=" + graduate_status + "&bln_masuk=" + bln_masuk
            let paramToSend7 = "&thn_masuk=" + thn_masuk + "&bln_lulus=" + bln_lulus
            let paramToSend8 = "&thn_lulus=" + thn_lulus
            
            let paramGroup1 = paramToSend + paramToSend2 + paramToSend3 + paramToSend4
            let paramGroup2 = paramToSend5 + paramToSend6 + paramToSend7 + paramToSend8
            let paramFinal = paramGroup1 + paramGroup2
            
            NetworkService.parseJSONFromURL(url, "POST", parameter: paramFinal){ (server_response) in
                
                if let message = server_response["message"] as? String {
                    Alert.showMessage(title: "WARNING!", msg: message)
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                }
            }

            
        } else {
            
            HUD.show(.progress)
            
            let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/education/"
            
            let paramToSend = "id_pendidikan=" + passedData + "&jenjang=" + id_jenjang + "&negara=" + id_negara
            let paramToSend2 = "&provinsi=" + id_provinsi + "&kota=" + id_kota
            let paramToSend3 = "&universitas=" + _university.text! + "&jurusan=" + _major.text!
            let paramToSend4 = "&akreditasi=" + _accreditation.text! + "&konsentrasi=" + _submajor.text!
            let paramToSend5 = "&judul_ta=" + _thesis.text! + "&ipk=" + _gpaScore.text!
            let paramToSend6 = "&sudah_lulus=" + graduate_status + "&bln_masuk=" + bln_masuk
            let paramToSend7 = "&thn_masuk=" + thn_masuk + "&bln_lulus=" + bln_lulus
            let paramToSend8 = "&thn_lulus=" + thn_lulus
            
            let paramGroup1 = paramToSend + paramToSend2 + paramToSend3 + paramToSend4
            let paramGroup2 = paramToSend5 + paramToSend6 + paramToSend7 + paramToSend8
            let paramFinal = paramGroup1 + paramGroup2
            
            NetworkService.parseJSONFromURL(url, "POST", parameter: paramFinal){ (server_response) in
                
                if let message = server_response["message"] as? String {
                   
                    DispatchQueue.main.async {
                        Alert.showMessage(title: "WARNING!", msg: message)
                        HUD.hide()
                    }
                }
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func doneButtonTappedForMyNumericTextField() {
        print("Done");
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
        
    }
    
}


