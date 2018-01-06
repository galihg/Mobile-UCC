//
//  WorkExperience.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/20/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class WorkExperience: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    
    var work = [Work]()
    
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
        self.title = "Work Experience"
        
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
        downloadAllExperience()
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
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        //addButton.setImage(UIImage(named: "add2"),for: UIControlState())
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControlState())
        addButton.addTarget(self, action: #selector(addWork), for: .touchUpInside)
        addButton.setTitle("         ADD WORK EXPERIENCE", for: [])
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    
    func downloadAllExperience () {
        
        work = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/jobseekers/cv_part/work")
        
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
                            let workDictionaries = server_response["data"] as! NSArray
                            
                            for workDictionary in workDictionaries {
                                let eachWork = workDictionary as! [String:Any]
                                let id_pekerjaan = eachWork ["id_pekerjaan"] as? String
                                let id_member = eachWork ["id_member"] as? String
                                let perusahaan = eachWork ["perusahaan"] as? String
                                let posisi = eachWork ["posisi"] as? String
                                let deskripsi = eachWork ["deskripsi"] as? String
                              
                                
                                self.work.append(Work(id_pekerjaan: id_pekerjaan!, id_member: id_member!, perusahaan: perusahaan!, posisi: posisi!, deskripsi: deskripsi!))
                            }
                            print(self.work)
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
        if work.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return work.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workCell", for: indexPath) as! workCell
        let work = self.work[indexPath.row]
        
        cell.work = work
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(WorkExperience.edit_work(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(WorkExperience.delete_work(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addWork(_ button: UIButton) {
        print("Button pressed 👍")
    }
    
    @IBAction func edit_work(_ sender: Any) {
    }
  
    
    @IBAction func delete_work(_ sender: Any) {
        let data = work[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let workId = data.id_pekerjaan
        
        let urlString4 = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/work/"
        
        //setLoadingScreen()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        deleteWork(urlString4, indexPath!, workId!)
    }
  
    
    func deleteWork (_ url:String, _ row:IndexPath,_ id:String) {
        
        
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
                            self.work.remove(at: row.row)
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

class Work
{
    var id_pekerjaan: String?
    var id_member: String?
    var perusahaan: String?
    var posisi: String?
    var deskripsi: String?
    var year_in: String?
    var year_out: String?
    var ipk: String?
    
    init(id_pekerjaan: String, id_member: String, perusahaan: String, posisi: String, deskripsi: String)
    {
        self.id_pekerjaan = id_pekerjaan
        self.id_member = id_member
        self.perusahaan = perusahaan
        self.posisi = posisi
        self.deskripsi = deskripsi
    }
    
}





