//
//  OrganizationExperience.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/27/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class OrganizationExperience: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var organisasi = [Organisasi]()
    
    // View which contains the loading text and the spinner
    let loadingView = UIView()
    
    // Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Organization Experience"
        
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "add"),for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(newButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        setLoadingScreen()
        downloadAllOrganization()
    }
    
    func newButtonAction(sender: UIBarButtonItem){
        
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2.3) - (width / 2.3)
        let y = (tableView.frame.height / 2.3) - (height / 2.3) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
    
    private func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 330, height: 63)
        //addButton.setImage(UIImage(named: "add2"),for: UIControlState())
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControlState())
        addButton.addTarget(self, action: #selector(addOrganization), for: .touchUpInside)
        addButton.setTitle("         ADD ORGANIZATION EXPERIENCE", for: [])
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    
    func downloadAllOrganization () {
        
        organisasi = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/jobseekers/cv_part/organization")
        
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "session") != nil)
            
        {
            
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [Any]
            
            let username = (preferences[0] as! String)
            let token = (preferences[1] as! String)
            
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
                        do {
                            let orgDictionaries = server_response["data"] as! NSArray
                            
                            for orgDictionary in orgDictionaries {
                                let eachOrg = orgDictionary as! [String:Any]
                                let id_org = eachOrg ["id_org"] as? String
                                let id_member = eachOrg ["id_member"] as? String
                                let namaOrg = eachOrg ["nama_org"] as? String
                                let posisi = eachOrg ["posisi"] as? String
                                let deskripsi = eachOrg ["deskripsi"] as? String
                                let tglMasuk = eachOrg ["tgl_masuk"] as? String
                                let tglKeluar = eachOrg ["tgl_keluar"] as? String
                                
                                
                                self.organisasi.append(Organisasi(id_organisasi: id_org!, id_member: id_member!, nama_organisasi: namaOrg!, posisi: posisi!, deskripsi: deskripsi!, year_in: tglMasuk!, year_out: tglKeluar!))
                            }
                            print(self.organisasi)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.removeLoadingScreen()
                            }
                            
                        }
                        
                    }
                    
                }
                
            })
            
            task.resume()
        }
        
        /*else
         {
         self.openViewControllerBasedOnIdentifier("Login Screen")
         }*/
    }
    
    
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if organisasi.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return organisasi.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "organizationCell", for: indexPath) as! organizationCell
        let organisasi = self.organisasi[indexPath.row]
        
        cell.organisasi = organisasi
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(OrganizationExperience.edit_org(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(OrganizationExperience.delete_org(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addOrganization(_ button: UIButton) {
        print("Button pressed 👍")
    }
    

    @IBAction func edit_org(_ sender: Any) {
        
    }
    
    
    @IBAction func delete_org(_ sender: Any) {
        let data = organisasi[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let orgId = data.id_organisasi
        
        let urlString4 = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/organization/"
        
        deleteOrg(urlString4, indexPath!, orgId!)
    }
  
    
    
    func deleteOrg(_ url:String, _ row:IndexPath,_ id:String) {
        
        
        let url = URL(string: url)
        
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "session") != nil)
            
        {
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [Any]
            
            let username = preferences[0] as! String
            let token = preferences[1] as! String
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
            
            let paramToSend = "id_pekerjaan=" + id
            
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
                        let message = server_response["message"] as? String
                        self.createAlert(title: "WARNING!", message: message!)
                        DispatchQueue.main.async {
                            self.organisasi.remove(at: row.row)
                            self.tableView.deleteRows(at: [row], with: .fade)
                        }
                        
                    }
                    else if (data_block=="error"){
                        let message = server_response["message"] as? String
                        self.createAlert(title: "WARNING!", message: message!)
                        
                        /*DispatchQueue.main.async {
                         self.tableView.reloadData()
                         }*/
                    }
                }
                
            })
            
            task.resume()
        }
        
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

class Organisasi
{
    var id_organisasi: String?
    var id_member: String?
    var nama_organisasi: String?
    var posisi: String?
    var deskripsi: String?
    var year_in: String?
    var year_out: String?
    
    init(id_organisasi: String, id_member: String, nama_organisasi: String, posisi: String, deskripsi: String, year_in: String, year_out: String)
    {
        self.id_organisasi = id_organisasi
        self.id_member = id_member
        self.nama_organisasi = nama_organisasi
        self.posisi = posisi
        self.deskripsi = deskripsi
        self.year_in = year_in
        self.year_out = year_out
    }
    
}





