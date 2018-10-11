//
//  PublicInformation.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditPublicInformation: BaseViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var _fullName: UITextField!
    @IBOutlet weak var _title: UITextField!
    @IBOutlet weak var _tempatLahir: UITextField!
    @IBOutlet weak var _tglLahir: UITextField!
    @IBOutlet weak var _hobi: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _IDNumber: UITextField!
    @IBOutlet weak var _phoneNumber: UITextField!
    @IBOutlet weak var _blog: UITextField!
    @IBOutlet weak var _ZIPCode: UITextField!{
        didSet {
            _ZIPCode.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet weak var _height: UITextField!{
        didSet {
            _height.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    
    @IBOutlet weak var religionBtn: UIButton!
    @IBOutlet weak var maritalBtn: UIButton!
    @IBOutlet weak var currentCountryBtn: UIButton!
    @IBOutlet weak var currentProvinceBtn: UIButton!
    @IBOutlet weak var currentCityBtn: UIButton!
    @IBOutlet weak var originCountryBtn: UIButton!
    @IBOutlet weak var originProvinceBtn: UIButton!
    @IBOutlet weak var originCityBtn: UIButton!
    
    @IBOutlet weak var maritalTable: UITableView!
    @IBOutlet weak var religionTable: UITableView!
    @IBOutlet weak var currentCountryTable: UITableView!
    @IBOutlet weak var currentProvinceTable: UITableView!
    @IBOutlet weak var currentCityTable: UITableView!
    @IBOutlet weak var originCountryTable: UITableView!
    @IBOutlet weak var originProvinceTable: UITableView!
    @IBOutlet weak var originCityTable: UITableView!
    
    @IBOutlet weak var currentAddress: UITextView!
    @IBOutlet weak var originAddress: UITextView!
    @IBOutlet weak var hospitalSheet: UITextView!
    
    @IBOutlet weak var currentProvinceLbl: UILabel!
    @IBOutlet weak var currentCityLbl: UILabel!
    @IBOutlet weak var ZIPCodeLbl: UILabel!
    @IBOutlet weak var originProvinceLbl: UILabel!
    @IBOutlet weak var originCityLbl: UILabel!
    
    @IBOutlet weak var radioBtn: DLRadioButton!
    @IBOutlet weak var radioBtn2: DLRadioButton!
    
    @IBOutlet weak var additionalInformationTopConstant: NSLayoutConstraint!
    @IBOutlet weak var originAddressTopConstant: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let bottomConstraintConstant: CGFloat = 29.0
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var country : String!
    var province : String!
    var city : String!
    
    var oriCountry : String!
    var oriProvince : String!
    var oriCity : String!
    
    var birthdate : String!
    var sex: String!

    let maritalArray = ["Single", "Married", "Widow", "Widower"]
    let religionArray = ["Islam", "Christian", "Catholic", "Hindu", "Buddha", "Other..."]
    
    var provinsi = [Provinsi]()
    var kota = [Kota]()
    var negara = [Negara]()
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        self.title = "Edit Public Information"
        
        _fullName.delegate = self
        _title.delegate = self
        _tempatLahir.delegate = self
        _tglLahir.delegate = self
        _hobi.delegate = self
        _email.delegate = self
        _IDNumber.delegate = self
        _phoneNumber.delegate = self
        _blog.delegate = self
        _ZIPCode.delegate = self
        _height.delegate = self
        
        currentAddress.delegate = self
        originAddress.delegate = self
        hospitalSheet.delegate = self
        
        currentAddress.layer.borderWidth = 1.0
        originAddress.layer.borderWidth = 1.0
        hospitalSheet.layer.borderWidth = 1.0
        
        setTable(maritalTable)
        setTable(religionTable)
        setTable(currentCountryTable)
        setTable(currentProvinceTable)
        setTable(currentCityTable)
        setTable(originCountryTable)
        setTable(originProvinceTable)
        setTable(originCityTable)
        
        maritalTable.isHidden = true
        religionTable.isHidden = true
        currentProvinceTable.isHidden = true
        currentCityTable.isHidden = true
        originCountryTable.isHidden = true
        originProvinceTable.isHidden = true
        originCityTable.isHidden = true
        
        currentProvinceLbl.isHidden = true
        currentProvinceBtn.isHidden = true
        currentCityLbl.isHidden = true
        currentCityBtn.isHidden = true
        ZIPCodeLbl.isHidden = true
        _ZIPCode.isHidden = true
        
        originProvinceLbl.isHidden = true
        originProvinceBtn.isHidden = true
        originCityLbl.isHidden = true
        originCityBtn.isHidden = true
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditPublicInformation.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditPublicInformation.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        datePicker.datePickerMode = .date
        //Add datePicker to textField
        _tglLahir.inputView = datePicker
        
        //Add toolbar to textField
        _tglLahir.inputAccessoryView = toolbar
        
        _height.keyboardType = UIKeyboardType.decimalPad
        _ZIPCode.keyboardType = UIKeyboardType.decimalPad
        
        
        getCountries()
        getProvinsi()
        getProfile()
        
        // Listen for the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func set_constraint(){
        
        let distance = 16 + currentProvinceLbl.frame.size.height + 8 + currentProvinceBtn.frame.size.height + 8 + currentCityLbl.frame.size.height
        let distance2 = 8 + currentCityBtn.frame.size.height + 8 + ZIPCodeLbl.frame.size.height + 8 + _ZIPCode.frame.size.height
        let distanceFinal = distance + distance2
        
        let distance3 = 41 + originProvinceLbl.frame.size.height + 8 + originProvinceBtn.frame.size.height + 8 + originCityLbl.frame.size.height + 8 + originCityBtn.frame.size.height
  
        if (country == "ID"){
            UIView.animate(withDuration: 0.25, animations: {
                self.originAddressTopConstant.constant = distanceFinal
                
                self.currentProvinceLbl.isHidden = false
                self.currentProvinceBtn.isHidden = false
                self.currentCityLbl.isHidden = false
                self.currentCityBtn.isHidden = false
                self.ZIPCodeLbl.isHidden = false
                self._ZIPCode.isHidden = false
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.originAddressTopConstant.constant = 8
            
                self.currentProvinceLbl.isHidden = true
                self.currentProvinceBtn.isHidden = true
                self.currentCityLbl.isHidden = true
                self.currentCityBtn.isHidden = true
                self.ZIPCodeLbl.isHidden = true
                self._ZIPCode.isHidden = true
            
            })
        }
        
        if(oriCountry != "ID"){
            UIView.animate(withDuration: 0.25, animations: {
                self.additionalInformationTopConstant.constant = 33
                
                self.originProvinceLbl.isHidden = true
                self.originProvinceBtn.isHidden = true
                self.originCityLbl.isHidden = true
                self.originCityBtn.isHidden = true
                
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.additionalInformationTopConstant.constant = distance3
                
                self.originProvinceLbl.isHidden = false
                self.originProvinceBtn.isHidden = false
                self.originCityLbl.isHidden = false
                self.originCityBtn.isHidden = false
                
            })
        }
    }
    
    func donedatePicker(){
        //For date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthdate = dateFormatter.string(from: datePicker.date)
        
        //display time
        dateFormatter.dateFormat = " dd MMM yyyy"
        self._tglLahir.text = dateFormatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }

    func getProfile() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    let data_dictionary = server_response["data"] as! NSDictionary
                    let fullName = data_dictionary["fullname"] as? String ?? "(empty)"
                    let academic = data_dictionary["academic_title"] as? String ?? "(empty)"
                    let birthdate = data_dictionary["birthdate"] as? String ?? "(empty)"
                    let birthplace = data_dictionary["birthplace"] as? String ?? "(empty)"
                    let blog = data_dictionary["blog"] as? String ?? "(empty)"
                    let email = data_dictionary["email"] as? String ?? "(empty"
                    let gender = data_dictionary["gender"] as? String ?? "(empty)"
                    let hobby = data_dictionary["hobby"] as? String ?? "(empty)"
                    let id_number = data_dictionary["id_number"] as? String ?? "(empty)"
                    let religion = data_dictionary["religion"] as? String ?? "(empty)"
                    let marriage = data_dictionary["marriage_status"] as? String ?? "(empty)"
                    let height = data_dictionary["body_height"] as? Int ?? 0
                    let current_address = data_dictionary["current_address"] as? String ?? "(empty)"
                    let current_city = data_dictionary["current_city"] as? String ?? "(empty)"
                    let id_current_city = data_dictionary["current_city_id"] as? String ?? "(empty)"
                    let current_province = data_dictionary["current_province"] as? String ?? "(empty)"
                    let id_current_province = data_dictionary["current_province_id"] as? String ?? "(empty)"
                    let current_zip = data_dictionary["current_zip"] as? String ?? "(empty)"
                    let current_country = data_dictionary["current_country"] as? String ?? "(empty)"
                    let origin_city = data_dictionary["origin_city"] as? String ?? "(empty)"
                    let id_origin_city = data_dictionary["origin_city_id"] as? String ?? "(empty)"
                    let origin_province = data_dictionary["origin_province"] as? String ?? "(empty)"
                    let id_origin_province = data_dictionary["origin_province_id"] as? String ?? "(empty)"
                    let origin_country = data_dictionary["origin_country"] as? String ?? "(empty)"
                    let origin_address = data_dictionary["origin_address"] as? String ?? "(empty"
                    let phone_number = data_dictionary["phone_number"] as? String ?? "(empty)"
                    let hospital_sheet = data_dictionary["hospital_sheet"] as? String ?? "(empty)"
                    
                    if (current_country == "indonesia") {
                        self.country = "ID"
                    } else {
                        self.country = current_country
                    }
                    
                    if (origin_country == "indonesia") {
                        self.oriCountry = "ID"
                    } else {
                        self.oriCountry = origin_country
                    }
                    
                    self.province = id_current_province
                    self.city = id_current_city
                    self.oriProvince = id_origin_province
                    self.oriCity = id_origin_city
                    self.sex = gender
                    self.birthdate = birthdate
                    
                    DispatchQueue.main.async {
                        self._fullName.text = fullName
                        self._title.text = academic
                        self._tempatLahir.text = birthplace
                        self._hobi.text = hobby
                        self._email.text = email
                        self._IDNumber.text = id_number
                        self._phoneNumber.text = phone_number
                        self._blog.text = blog
                        self._ZIPCode.text = current_zip
                        self._height.text = "\(height)"
                        
                        self.currentAddress.text = current_address
                        self.originAddress.text = origin_address
                        self.hospitalSheet.text = hospital_sheet
                        
                        if (marriage == "lajang"){
                            self.maritalBtn.setTitle("Single", for: [])
                        }
                        
                        if (religion == "islam"){
                            self.religionBtn.setTitle("Islam", for: [])
                        }
                        
                        if (self.sex == "L") {
                            self.radioBtn.isSelected = true
                        } else {
                            self.radioBtn2.isSelected = true
                        }
                        
                        let date = birthdate
                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateFromString : NSDate  = self.dateFormatter.date(from: date)! as NSDate
                        
                        self.dateFormatter.dateFormat = "dd MMM yyyy"
                        let datenew = self.dateFormatter.string(from: dateFromString as Date)
                        self._tglLahir.text = datenew
                        
                        self.currentCountryBtn.setTitle(current_country, for: [])
                        self.originCountryBtn.setTitle(origin_country, for: [])
                        self.currentProvinceBtn.setTitle(current_province, for: [])
                        self.originProvinceBtn.setTitle(origin_province, for: [])
                        self.currentCityBtn.setTitle(current_city, for: [])
                        self.originCityBtn.setTitle(origin_city, for: [])
                        
                        self.set_constraint()
                        
                        HUD.hide()
                        
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
                        self.currentProvinceTable.reloadData()
                        self.originProvinceTable.reloadData()
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
                        self.currentCountryTable.reloadData()
                        self.originCountryTable.reloadData()
                    }
                    
                }
            }
        }
        
    }
    
    func getKota(_ id: String, _ tipe: String) {
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
                        if (tipe == "current") {
                            self.currentCityTable.reloadData()
                        } else {
                            self.originCityTable.reloadData()
                        }
                    }
                    
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setTable(_ table:UITableView) {
        table.estimatedRowHeight = table.rowHeight
        table.rowHeight = UITableViewAutomaticDimension
        table.dataSource = self
        table.delegate = self
        table.isHidden = true
    }
    
    func resignResponder() {
        _fullName.resignFirstResponder()
        _title.resignFirstResponder()
        _tempatLahir.resignFirstResponder()
        _tglLahir.resignFirstResponder()
        _hobi.resignFirstResponder()
        _email.resignFirstResponder()
        _IDNumber.resignFirstResponder()
        _phoneNumber.resignFirstResponder()
        _blog.resignFirstResponder()
        _ZIPCode.resignFirstResponder()
        _height.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == maritalTable) {
            return maritalArray.count
        } else if (tableView == religionTable) {
            return religionArray.count
        } else if (tableView == currentCountryTable) {
            return negara.count
        } else if (tableView == currentProvinceTable) {
            return provinsi.count
        } else if (tableView == currentCityTable) {
            return kota.count
        } else if (tableView == originCountryTable) {
            return negara.count
        } else if (tableView == originProvinceTable) {
            return provinsi.count
        } else {
            return kota.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == maritalTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "maritalCell", for: indexPath)
            cell.textLabel?.text = maritalArray[indexPath.row]
            cell.textLabel?.sizeToFit()
            
            return cell
            
        } else if (tableView == religionTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "religionCell", for: indexPath)
            cell.textLabel?.text = religionArray[indexPath.row]
            cell.textLabel?.sizeToFit()
            
            return cell
            
        } else if (tableView == currentCountryTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentCountryCell", for: indexPath)
            let negara = self.negara[indexPath.row]
            
            cell.textLabel?.text = negara.nama_negara
            cell.textLabel?.sizeToFit()
            
            return cell
            
        } else if (tableView == currentProvinceTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentProvinceCell", for: indexPath)
            let provinsi = self.provinsi[indexPath.row]
            
            cell.textLabel?.text = provinsi.nama_provinsi
            cell.textLabel?.sizeToFit()
            
            return cell
            
        } else if (tableView == currentCityTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentCityCell", for: indexPath)
            let kota = self.kota[indexPath.row]
            
            cell.textLabel?.text = kota.nama_kota
            cell.textLabel?.sizeToFit()
            
            return cell
            
        } else if (tableView == originCountryTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "originCountryCell", for: indexPath)
            let negara = self.negara[indexPath.row]
            
            cell.textLabel?.text = negara.nama_negara
            cell.textLabel?.sizeToFit()
            
            return cell
            
        } else if (tableView == originProvinceTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "originProvinceCell", for: indexPath)
            let provinsi = self.provinsi[indexPath.row]
            
            cell.textLabel?.text = provinsi.nama_provinsi
            cell.textLabel?.sizeToFit()
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "originCityCell", for: indexPath)
            let kota = self.kota[indexPath.row]
            
            cell.textLabel?.text = kota.nama_kota
            cell.textLabel?.sizeToFit()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        if (tableView == currentCountryTable) {
            
            let negara = self.negara[indexPath.row]
            let countryName = negara.nama_negara
            let countryId = negara.id_negara
            let index = indexPath
            let tipe = "negara1"
            
            parsingPlace(currentCountryTable, countryName!, countryId!, currentCountryBtn, index, tipe)
            set_constraint()
            
        } else if (tableView == currentProvinceTable) {
            
            let provinsi = self.provinsi[indexPath.row]
            let provinceName = provinsi.nama_provinsi
            let provinceId = provinsi.id_provinsi
            let index = indexPath
            let tipe = "provinsi1"
            
            parsingPlace(currentProvinceTable, provinceName!, provinceId!, currentProvinceBtn, index, tipe)
            
        }  else if (tableView == currentCityTable) {
            
            let city = self.kota[indexPath.row]
            let cityName = city.nama_kota
            let cityId = city.id_kota
            let index = indexPath
            let tipe = "kota1"
            
            parsingPlace(currentCityTable, cityName!, cityId!, currentCityBtn, index, tipe)
            
        } else if (tableView == originCountryTable) {
            
            let negara = self.negara[indexPath.row]
            let countryName = negara.nama_negara
            let countryId = negara.id_negara
            let index = indexPath
            let tipe = "negara2"
            
            parsingPlace(originCountryTable, countryName!, countryId!, originCountryBtn, index, tipe)
            set_constraint()
            
        } else if (tableView == originProvinceTable) {
            
            let provinsi = self.provinsi[indexPath.row]
            let provinceName = provinsi.nama_provinsi
            let provinceId = provinsi.id_provinsi
            let index = indexPath
            let tipe = "provinsi2"
            
            parsingPlace(originProvinceTable, provinceName!, provinceId!, originProvinceBtn, index, tipe)
            
        } else if (tableView == originCityTable) {
            
            let city = self.kota[indexPath.row]
            let cityName = city.nama_kota
            let cityId = city.id_kota
            let index = indexPath
            let tipe = "kota2"
            
            parsingPlace(originCityTable, cityName!, cityId!, originCityBtn, index, tipe)
            
        } else if (tableView == religionTable) {
            
            let religion = religionArray[indexPath.row]
            let index = indexPath
            let tipe = "religion"
            
            parsingPlace(religionTable, religion, "", religionBtn, index, tipe)
            
        } else {
            let marital = maritalArray[indexPath.row]
            let index = indexPath
            let tipe = "marital"
            
            parsingPlace(maritalTable, marital, "", maritalBtn, index, tipe)
            
        }
    }
    
    func parsingPlace(_ tableView: UITableView, _ name: String, _ id: String, _ button: UIButton, _ indexPath:
        IndexPath, _ tipe: String) {
        
        if (tipe == "negara1") {
            country = id
        } else if (tipe == "provinsi1") {
            if ( id != province ){
                province = id
                city = ""
            }
        } else if (tipe == "kota1") {
            city = id
        } else if (tipe == "negara2") {
            oriCountry = id
        } else if (tipe == "provinsi2") {
            if ( id != oriProvince ){
                oriProvince = id
                oriCity = ""
            }
        } else if (tipe == "kota2") {
            oriCity = id
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        button.setTitle(name, for: [])
        
    }

    @IBAction func radioBtnAction(_ sender: DLRadioButton) {
        
        if (sender.tag == 1) {
            radioBtn2.isSelected = false
            sex = "L"
            print ("Male")
        } else if (sender.tag == 2){
            radioBtn.isSelected = false
            sex = "P"
            print ("Female")
        }
    }
    
    @IBAction func setMarital(_ sender: Any) {
        
        if (maritalTable.isHidden == true) {
            
            maritalTable.isHidden = false
            religionTable.isHidden = true
            currentCountryTable.isHidden = true
            currentProvinceTable.isHidden = true
            currentCityTable.isHidden = true
            originCountryTable.isHidden = true
            originProvinceTable.isHidden = true
            originCityTable.isHidden = true
            
        } else {
            maritalTable.isHidden = true
        }
    }
    
    @IBAction func setReligion(_ sender: Any) {
        
        if (religionTable.isHidden == true) {
            
            religionTable.isHidden = false
            maritalTable.isHidden = true
            currentCountryTable.isHidden = true
            currentProvinceTable.isHidden = true
            currentCityTable.isHidden = true
            originCountryTable.isHidden = true
            originProvinceTable.isHidden = true
            originCityTable.isHidden = true
            
        } else {
            religionTable.isHidden = true
        }
    }
    
    @IBAction func setCurrentCountry(_ sender: Any) {
        
        if (currentCountryTable.isHidden == true) {
            
            religionTable.isHidden = true
            maritalTable.isHidden = true
            currentCountryTable.isHidden = false
            currentProvinceTable.isHidden = true
            currentCityTable.isHidden = true
            originCountryTable.isHidden = true
            originProvinceTable.isHidden = true
            originCityTable.isHidden = true
            
        } else {
            currentCountryTable.isHidden = true
        }
    }
    
    @IBAction func setCurrentProvince(_ sender: Any) {
        
        if (currentProvinceTable.isHidden == true) {
            
            religionTable.isHidden = true
            maritalTable.isHidden = true
            currentCountryTable.isHidden = true
            currentProvinceTable.isHidden = false
            currentCityTable.isHidden = true
            originCountryTable.isHidden = true
            originProvinceTable.isHidden = true
            originCityTable.isHidden = true
            
        } else {
            currentProvinceTable.isHidden = true
        }
    }
    
    @IBAction func setCurrentCity(_ sender: Any) {
        
        getKota(province, "current")
        if (currentProvinceTable.isHidden == true) {
            
            religionTable.isHidden = true
            maritalTable.isHidden = true
            currentCountryTable.isHidden = true
            currentProvinceTable.isHidden = true
            currentCityTable.isHidden = false
            originCountryTable.isHidden = true
            originProvinceTable.isHidden = true
            originCityTable.isHidden = true
            
        } else {
            currentCityTable.isHidden = true
        }
    }
    
    @IBAction func setOriginCountry(_ sender: Any) {
        
        if (originCountryTable.isHidden == true) {
            
            religionTable.isHidden = true
            maritalTable.isHidden = true
            currentCountryTable.isHidden = true
            currentProvinceTable.isHidden = true
            currentCityTable.isHidden = true
            originCountryTable.isHidden = false
            originProvinceTable.isHidden = true
            originCityTable.isHidden = true
            
        } else {
            originCountryTable.isHidden = true
        }
    }
    
    @IBAction func setOriginProvince(_ sender: Any) {
        
        if (originProvinceTable.isHidden == true) {
            
            religionTable.isHidden = true
            maritalTable.isHidden = true
            currentCountryTable.isHidden = true
            currentProvinceTable.isHidden = true
            currentCityTable.isHidden = true
            originCountryTable.isHidden = true
            originProvinceTable.isHidden = false
            originCityTable.isHidden = true
            
        } else {
            originProvinceTable.isHidden = true
        }
    }
    
    @IBAction func setOriginCity(_ sender: Any) {
        
        getKota(oriProvince, "ori")
        
        if (originCityTable.isHidden == true) {
            
            religionTable.isHidden = true
            maritalTable.isHidden = true
            currentCountryTable.isHidden = true
            currentProvinceTable.isHidden = true
            currentCityTable.isHidden = true
            originCountryTable.isHidden = true
            originProvinceTable.isHidden = true
            originCityTable.isHidden = false
            
        } else {
            originCityTable.isHidden = true
        }
    }
    
    func doneButtonTappedForMyNumericTextField() {
        print("Done");
        resignResponder()
        UIView.animate(withDuration: 0.5, animations: {
            
            self.bottomConstraint.constant = self.bottomConstraintConstant
            self.view.layoutIfNeeded()
            
        })
    }
    
    @IBAction func submitProfile(_ sender: Any) {
        resignResponder()
        HUD.show(.progress)
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/basic"
        
        let paramToSend = "fullname=" + _fullName.text! + "&title=" + _title.text!
        let paramToSend2 = "&birthplace=" + _tempatLahir.text! + "&birthdate=" + birthdate
        let paramToSend3 = "&gender=" + sex + "&religion=" + religionBtn.title(for:[] )!
        let paramToSend4 = "&hobby=" + _hobi.text! + "&marriage_status=" + maritalBtn.title(for: [])!
        let paramToSend5 = "&email=" + _email.text! + "&id_number=" + _IDNumber.text!
        let paramToSend6 = "&phone_number" + _phoneNumber.text! + "&blog=" + _blog.text!
        let paramToSend7 = "&current_address=" + currentAddress.text! + "&current_country=" + "ID"
        let paramToSend8 = "&current_province_id=" + province + "&current_city_id=" + city
        let paramToSend9 = "&current_zip=" + _ZIPCode.text! + "&origin_address=" + originAddress.text!
        let paramToSend10 = "&origin_country=" + oriCountry + "&origin_province_id=" + oriProvince + "&origin_city_id=" + oriCity
        let paramToSend11 = "&body_height=" + _height.text! + "&hospital_sheet=" + hospitalSheet.text!
        
        let paramGroup1 = paramToSend + paramToSend2 + paramToSend3 + paramToSend4
        let paramGroup2 = paramToSend5 + paramToSend6 + paramToSend7 + paramToSend8
        let paramGroup3 = paramToSend9 + paramToSend10 + paramToSend11
        let paramFinal = paramGroup1 + paramGroup2 + paramGroup3
        
        NetworkService.parseJSONFromURL(url, "POST", parameter: paramFinal){ (server_response) in
            if let message = server_response["message"] as? String {
                
                DispatchQueue.main.async {
                    Alert.showMessage(title: "WARNING!", msg: message)
                    HUD.hide()
                }
                
            } 
        }
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
