//
//  EditEducation.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 02/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EditEducation: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var btnDegree: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var _university: UITextField!
    @IBOutlet weak var _major: UITextField!
    @IBOutlet weak var _accreditation: UITextField!
    
    @IBOutlet weak var universityTop: NSLayoutConstraint!
    @IBOutlet weak var universityBottom: NSLayoutConstraint!
    @IBOutlet weak var majorTop: NSLayoutConstraint!
    @IBOutlet weak var majorBottom: NSLayoutConstraint!
    @IBOutlet weak var accreditationTop: NSLayoutConstraint!
    @IBOutlet weak var accreditationBottom: NSLayoutConstraint!
    
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var btnProvince: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var btnCity: UIButton!
    
    @IBOutlet weak var degreeTable: UITableView!
    @IBOutlet weak var countryTable: UITableView!
    @IBOutlet weak var provinceTable: UITableView!
    @IBOutlet weak var cityTable: UITableView!
    
    
    @IBOutlet weak var contentView: UIView!
    
    let items = ["Strata I", "Strata II", "Strata III", "SMA/SMK Sederajat", "Diploma"]
    
    var isIndonesia: Bool? = true
    var passedData: String!
    var id_negara: String!
    var id_provinsi: String!
    var id_kota: String!
    
    var provinsi = [Provinsi]()
    var kota = [Kota]()
    var negara = [Negara]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Edit Education"
        
        setTable(countryTable)
        setTable(degreeTable)
        setTable(provinceTable)
        setTable(cityTable)
        
        provinceLabel.isHidden = true
        btnProvince.isHidden = true
        cityLabel.isHidden = true
        btnCity.isHidden = true
        
        print(passedData)
        
        _university.delegate = self
        _major.delegate = self
        _accreditation.delegate = self
        
        auth_chech()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
  
    }
    
    func auth_chech() {
        
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    
                    DispatchQueue.main.async {
                        if (self.passedData == "-1") {
                            
                            //let urlString2 = "http://api.career.undip.ac.id/v1/jobseekers/add_cv_part/education"
                            self.getCountries()
                            self.getProvinsi()
                            
                        } else {
                            
                            //let urlString = "http://api.career.undip.ac.id/v1/jobseekers/detail_cv_part/education"
                            //let urlString2 = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/education"
                            
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
    
    func setConstraint(_ id: String) {
        
        let distance = cityLabel.frame.size.height + 8 + btnCity.frame.size.height + 8 + provinceLabel.frame.size.height + 8 + btnProvince.frame.size.height + 8 + 16
        
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
                
                self.universityTop.constant = 8 + distance
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
                    
                    if (self.id_negara != nil) {
                        self.getCountries()
                    }
                    
                    if (self.id_provinsi != nil) {
                        self.getProvinsi()
                        
                        if (self.id_kota != nil) {
                            self.getKota(self.id_provinsi)
                        }
                    }
                    
                    
                    print(self.passedData)
                    print(self.id_provinsi)
                    
                    DispatchQueue.main.async {
            
                        self.btnDegree.setTitle(jenjang, for: [])
                    
                    }
                }
            }
        }
    
    }
    
    func getProvinsi() {
        
        provinsi = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/location/provinces/" )
        
        let defaults = UserDefaults.standard
        if let session = defaults.object(forKey: "session")
        {
            
            let preference_block = session
            var preferences = preference_block as! [Any]
            
            let username = preferences[0] as! String
            let token = preferences[1] as! String
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else
                {
                    return
                }
                
                let json:Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch
                {
                    return
                }
                
                
                guard let server_response = json as? [String:Any] else
                {
                    return
                }
                
                
                if let data_block = server_response["status"] as? String
                {
                    
                    
                    if (data_block=="ok") {
                        
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
                
            })
            
            task.resume()
        }
        
    }
    
    func getCountries() {
        
        negara = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/location/countries/" )
        
        let defaults = UserDefaults.standard
        if let session = defaults.object(forKey: "session")
        {
            
            let preference_block = session
            var preferences = preference_block as! [Any]
            
            let username = preferences[0] as! String
            let token = preferences[1] as! String
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else
                {
                    return
                }
                
                let json:Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch
                {
                    return
                }
                
                
                guard let server_response = json as? [String:Any] else
                {
                    return
                }
                
                
                if let data_block = server_response["status"] as? String
                {
                    
                    
                    if (data_block=="ok") {
                        
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
                
            })
            
            task.resume()
        }
        
    }
    
    func getKota(_ id: String) {
        kota = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/location/cities/" + id )
        
        let defaults = UserDefaults.standard
        if let session = defaults.object(forKey: "session")
        {
            
            let preference_block = session
            var preferences = preference_block as! [Any]
            
            let username = preferences[0] as! String
            let token = preferences[1] as! String
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else
                {
                    return
                }
                
                let json:Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch
                {
                    return
                }
                
                
                guard let server_response = json as? [String:Any] else
                {
                    return
                }
                
                
                if let data_block = server_response["status"] as? String
                {
                    
                    
                    if (data_block=="ok") {
                        
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
                            
                            if (self.passedData != "-1") {
                                let namaKota = self.filterPosisi(id: self.id_kota!, tipe: "kota")
                                print(namaKota)
                                self.btnCity.setTitle(namaKota, for: [])
                            }
                        }
                        
                        
                        
                        
                        
                    }
                    
                }
                
            })
            
            task.resume()
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
                }
            }
        } else if (tipe == "provinsi") {
            let rawEntity = self.provinsi
            
            for entitas in rawEntity {
                
                if (id == entitas.id_provinsi){
                    filteredName = entitas.nama_provinsi
                    break
                }
            }
           
        } else if (tipe == "kota") {
            let rawEntity = self.kota
            
            for entitas in rawEntity {
                
                if (id == entitas.id_kota){
                    filteredName = entitas.nama_kota
                    break
                } else {
                    filteredName = ""
                }
            }
        }
        
        return filteredName
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView == countryTable) {
            return negara.count
        } else if (tableView == provinceTable) {
            return provinsi.count
        } else if (tableView == cityTable) {
            return kota.count
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
            
            cell.textLabel?.text = self.items[indexPath.row]
            cell.textLabel?.sizeToFit()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            let kota = self.kota[indexPath.row]
            
            cell.textLabel?.text = kota.nama_kota
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
            }
        } else if (tipe == "kota") {
            id_kota = id
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
    
    
}
