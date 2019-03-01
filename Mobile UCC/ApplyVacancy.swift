//
//  ApplyVacancy.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/31/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class ApplyVacancy: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var provinceTable: UITableView!
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var btn_provinsi: UIButton!
    @IBOutlet weak var btn_city: UIButton!
    @IBOutlet weak var checkbox: UIButton!
    
    var checked : Bool!
    var id_province : String!
    var id_city : String!
    
    var provinsi = [Provinsi]()
    var kota = [Kota]()
    
    var passedData : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "session") != nil ) {
            Auth.auth_check()
        }
        
        provinsi = Provinsi.downloadAllProvince()
        checked = false

        //bagian tabel
        setTable(provinceTable)
        setTable(cityTable)
        
        auth_check()
        //downloadAllProvince()
        provinceTable.reloadData()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
        self.title = "Apply Vacancy"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ViewControllers view ist fully loaded and could present further ViewController
        //Here you could do any other UI operations
        if Reachability.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            controller.addAction(ok)
            controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    func setTable(_ table:UITableView) {
        table.estimatedRowHeight = table.rowHeight
        table.rowHeight = UITableView.automaticDimension
        table.dataSource = self
        table.delegate = self
        table.isHidden = true
    }
    
    func auth_check() {
        
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    
                    DispatchQueue.main.async {
                        return
                    }
                    
                } else if (status == "invalid-session"){
                    
                    let preferences = UserDefaults.standard
                    preferences.removeObject(forKey: "session")
                    
                    DispatchQueue.main.async {
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

    func downloadAllCity (_ url:String) {
        
        kota = []
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                
                if (status == "ok"){
                    
                    let cityDictionaries = server_response["data"] as! NSArray
                    
                    for cityDictionary in cityDictionaries {
                        let eachCity = cityDictionary as! [String:Any]
                        
                        let id_kota = eachCity["id"] as? String
                        let nama_kota = eachCity["name"] as? String
                        
                        self.kota.append(Kota(id_kota: id_kota!, nama_kota: nama_kota!))
                    }
                   
                    DispatchQueue.main.async (
                        execute:self.cityTable.reloadData
                    )
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView == provinceTable) {
            return provinsi.count
        }
        else {
            return kota.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView == provinceTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell", for: indexPath)
            let provinsi = self.provinsi[indexPath.row]
            
            cell.textLabel?.text = provinsi.nama_provinsi
            cell.textLabel?.sizeToFit()
            return cell
        }
        else {
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
        if (tableView == provinceTable) {
            let provinsi = self.provinsi[indexPath.row]
            let provinceName = provinsi.nama_provinsi
            let provinceId = provinsi.id_provinsi
            self.id_province = provinceId
            
            provinceTable.deselectRow(at: indexPath, animated: true)
            provinceTable.isHidden = true
            btn_provinsi.setTitle(provinceName, for: [])
        } else {
            let kota = self.kota[indexPath.row]
            let cityName = kota.nama_kota
            let cityId = kota.id_kota
            self.id_city = cityId
            
            cityTable.deselectRow(at: indexPath, animated: true)
            cityTable.isHidden = true
            btn_city.setTitle(cityName, for: [])
        }
    }
    
    @IBAction func get_province(_ sender: Any) {
        if (provinceTable.isHidden == true) {
            provinceTable.isHidden = false
            cityTable.isHidden = true
        }
        else {
            provinceTable.isHidden = true
        }
    }
    
    @IBAction func get_city(_ sender: Any) {
        
        if (cityTable.isHidden == true) {
            
            provinceTable.isHidden = true
            print(self.id_province)
            
            if let id = self.id_province {
                let urlString = "http://api.career.undip.ac.id/v1/location/cities/" + id
                cityTable.isHidden = false
                downloadAllCity(urlString)
            }
            else {
                Alert.showMessage(title: "WARNING!", msg: "Pilih provinsi terlebih dahulu!")
            }
            
        }
        else {
            cityTable.isHidden = true
        }
    }
    
    @IBAction func checked_btn(_ sender: Any) {
        if (checked == false) {
            self.checked = true
            checkbox.setImage(UIImage(named: "checked box.png")!, for: UIControl.State.normal)
        }
        else if (checked == true){
            self.checked = false
            checkbox.setImage(UIImage(named: "unchecked box.png")!, for: UIControl.State.normal)
        }
        
    }
    
    @IBAction func submit_vacancy(_ sender: Any) {
        if (self.checked == true) {
            if ((self.id_province != nil) && self.id_city != nil) {
                let statement = "read"
                let id_vacancy =  passedData
                print(statement)
                print(self.id_province)
                print(self.id_city)
                DoApply(id_vacancy, self.id_province, self.id_city, statement)
                
            }
            else {
                Alert.showMessage(title: "WARNING!", msg: "Silakan pilih provinsi dan kota domisili.")
            }
        }
        else if (self.checked == false) {
            let statement = "unread"
            print(statement)
            Alert.showMessage(title: "WARNING!", msg: "Anda harus menekan tombol centang terlebih dahulu")
        }
    }
    func DoApply(_ id1:String, _ id2:String, _ id3:String, _ stat:String)
    {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/applications/list"
            
        let paramToSend = "offer_id=" + id1 + "&current_province=" + id2 + "&current_city=" + id3 + "&statement=" + stat
        
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

