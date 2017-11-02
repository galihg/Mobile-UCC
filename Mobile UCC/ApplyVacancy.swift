//
//  ApplyVacancy.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/31/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class ApplyVacancy: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var provinceTable: UITableView!
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var btn_provinsi: UIButton!
    @IBOutlet weak var btn_city: UIButton!
    @IBOutlet weak var checkbox: UIButton!
    
    //var indicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var checked : Bool!
    var id_province : String!
    var id_city : String!
    
    var provinsi = [Provinsi]()
    var kota = [Kota]()
    
    var passedData : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apply Vacancy"
        
        checked = false
        provinceTable.isHidden = true
        cityTable.isHidden = true
        
        //bagian tabel
        provinceTable.estimatedRowHeight = provinceTable.rowHeight
        provinceTable.rowHeight = UITableViewAutomaticDimension
        provinceTable.dataSource = self
        provinceTable.delegate = self
        
        cityTable.estimatedRowHeight = provinceTable.rowHeight
        cityTable.rowHeight = UITableViewAutomaticDimension
        cityTable.dataSource = self
        cityTable.delegate = self
        
        
        let urlString = "http://api.career.undip.ac.id/v1/location/provinces/"
        downloadAllProvince(urlString)
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
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
    


    func downloadAllProvince (_ url:String) {
        
        provinsi = []
        
        let url = URL(string: url)
        
        //let defaults = UserDefaults.standard
        
        //if(defaults.object(forKey: "session") != nil)
        if(true)
        {
            /*let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
            
            let username = preferences[0]
            let token = preferences[1]
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()*/
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
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
                    json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
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
                        do {
                            let provinceDictionaries = server_response["data"] as! NSArray

                            for provinceDictionary in provinceDictionaries {
                                let eachProvince = provinceDictionary as! [String:Any]
                                
                                let id_provinsi = eachProvince["id"] as? String
                                let nama_provinsi = eachProvince["name"] as? String
                                
                                self.provinsi.append(Provinsi(id_provinsi: id_provinsi!, nama_provinsi: nama_provinsi!))
                            }
                            print(self.provinsi)
                            DispatchQueue.main.async (
                                execute:self.provinceTable.reloadData
                            )
                        }
                        
                    }
                    else if (data_block=="invalid-session"){
                        DispatchQueue.main.async (
                            execute:self.LoginError
                        )
                    }
                }
                
            })
            
            task.resume()
        }
            
        else
        {
            self.openViewControllerBasedOnIdentifier("Login Screen")
        }
    }
    
    func downloadAllCity (_ url:String) {
        
        kota = []
        
        let url = URL(string: url)
        
        let defaults = UserDefaults.standard
        
        if(defaults.object(forKey: "session") != nil)
        {
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
            
            let username = preferences[0]
            let token = preferences[1]
            
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
                    json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
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
                        do {
                            let cityDictionaries = server_response["data"] as! NSArray
                            
                            for cityDictionary in cityDictionaries {
                                let eachCity = cityDictionary as! [String:Any]
                                
                                let id_kota = eachCity["id"] as? String
                                let nama_kota = eachCity["name"] as? String
                                
                                self.kota.append(Kota(id_kota: id_kota!, nama_kota: nama_kota!))
                            }
                            print(self.kota)
                            DispatchQueue.main.async (
                                execute:self.cityTable.reloadData
                            )
                        }
                        
                    }
                    else if (data_block=="invalid-session"){
                        DispatchQueue.main.async (
                            execute:self.LoginError
                        )
                    }
                }
                
            })
            
            task.resume()
        }
            
        else
        {
            self.openViewControllerBasedOnIdentifier("Login Screen")
        }
    }
    
    func LoginError() {
        self.openViewControllerBasedOnIdentifier("Login Screen")
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
        }
        else {
            provinceTable.isHidden = true
        }
    }
    
    @IBAction func get_city(_ sender: Any) {
        
        if (cityTable.isHidden == true) {
            cityTable.isHidden = false
            print(self.id_province)
            
            if let id = self.id_province {
                let urlString = "http://api.career.undip.ac.id/v1/location/cities/" + id
                downloadAllCity(urlString)
            }
            else {
                createAlert(title: "WARNING!", message: "Pilih provinsi terlebih dahulu!")
            }
            
            
            
            /*if let indexPath = provinceTable.indexPathForSelectedRow {
                let rawId = self.provinsi[(indexPath.row)]
                let id = rawId.id_provinsi
                print (id!)
                let urlString = "http://uat.career.undip.ac.id/restapi/location/cities/" + id!
                downloadAllCity(urlString)
            }*/
        }
        else {
            cityTable.isHidden = true
        }
    }
    
    @IBAction func checked_btn(_ sender: Any) {
        if (checked == false) {
            self.checked = true
            checkbox.setImage(UIImage(named: "checked box.png")!, for: UIControlState.normal)
        }
        else if (checked == true){
            self.checked = false
            checkbox.setImage(UIImage(named: "unchecked box.png")!, for: UIControlState.normal)
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
                
                /*indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                indicator.center = self.view.center
                self.view.addSubview(indicator)
                indicator.startAnimating()
                indicator.backgroundColor = UIColor.white*/
            }
            else {
                createAlert(title: "WARNING!", message: "Silakan pilih provinsi dan kota domisili.")
            }
        }
        else if (self.checked == false) {
            let statement = "unread"
            print(statement)
            createAlert(title: "WARNING!", message: "Anda harus menekan tombol centang terlebih dahulu")
        }
    }
    func DoApply(_ id1:String, _ id2:String, _ id3:String, _ stat:String)
    {
      
        let defaults = UserDefaults.standard
        let url = URL(string: "http://api.career.undip.ac.id/v1/applications/list")
        
        if(defaults.object(forKey: "session") != nil)
        {
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
            
            let username = preferences[0]
            let token = preferences[1]
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
            let paramToSend = "offer_id=" + id1 + "&current_province=" + id2 + "&current_city=" + id3 + "&statement=" + stat
            
            request.httpBody = paramToSend.data(using: String.Encoding.utf8)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else
                {
                    return
                }
                
                let json:Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
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
                        do {
                            let message = server_response["message"] as? String
                            self.createAlert(title: "WARNING!", message: message!)
                           
                            /*DispatchQueue.main.async (
                                execute:self.indicator.stopAnimating
                                self.indicator.hidesWhenStopped = true
                            )*/
                           
                        }
                        
                        
                    }
                    else if (data_block=="error"){
                        let message = server_response["message"] as? String
                        self.createAlert(title: "WARNING!", message: message!)
                    }
                }
                
            })
            
            task.resume()
        }
            
        else
        {
            self.openViewControllerBasedOnIdentifier("Login Screen")
        }
        
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        /*let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200);
        
        let width : NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300);
        
        alert.view.addConstraint(height);
        
        alert.view.addConstraint(width);*/
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

}

class Provinsi
{
    var id_provinsi: String?
    var nama_provinsi: String?
    
    init(id_provinsi: String, nama_provinsi: String)
    {
        self.id_provinsi = id_provinsi
        self.nama_provinsi = nama_provinsi
    }
}

class Kota
{
    var id_kota: String?
    var nama_kota: String?
    
    init(id_kota: String, nama_kota: String)
    {
        self.id_kota = id_kota
        self.nama_kota = nama_kota
    }
}
