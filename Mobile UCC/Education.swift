//
//  Education.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class Education: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    
    var pendidikan = [Pendidikan]()
    
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
        self.title = "Education"
        
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
        downloadAllEducation()
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
        addButton.addTarget(self, action: #selector(addEducation), for: .touchUpInside)
        addButton.setTitle("         ADD FORMAL EDUCATION", for: [])
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    func downloadAllEducation () {
        
        pendidikan = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/jobseekers/cv_part/education")
        
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
                            let educationDictionaries = server_response["data"] as! NSArray
                            
                            for educationDictionary in educationDictionaries {
                                let eachEducation = educationDictionary as! [String:Any]
                                let id_education = eachEducation ["id_pddk"] as? String
                                let id_member = eachEducation ["id_member"] as? String
                                let degree = eachEducation ["jenjang"] as? String
                                let univ_name = eachEducation ["universitas"] as? String
                                let major = eachEducation ["jurusan"] as? String
                                let year_in = eachEducation ["thn_masuk"] as? String
                                let year_out = eachEducation ["thn_lulus"] as? String
                                let ipk = eachEducation ["ipk"] as? String
                                
                                self.pendidikan.append(Pendidikan(id_education: id_education!, id_member: id_member!, degree: degree!, univ_name: univ_name!, major: major!, year_in: year_in!, year_out: year_out!, ipk: ipk!))
                            }
                            print(self.pendidikan)
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
        if pendidikan.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return pendidikan.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell", for: indexPath) as! educationCell
        let pendidikan = self.pendidikan[indexPath.row]
        
        cell.pendidikan = pendidikan
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(Education.edit_education(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(Education.delete_education(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addEducation(_ button: UIButton) {
        print("Button pressed 👍")
    }
    
    @IBAction func edit_education(_ sender: Any) {
    }
    
    @IBAction func delete_education(_ sender: Any) {
        let data = pendidikan[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let educationId = data.id_education
        //let educationId_Int = Int(educationId!)
        
        let urlString4 = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/education/"
        
        //setLoadingScreen()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        deleteEducation(urlString4, indexPath!, educationId!)
    }
    
    func deleteEducation (_ url:String, _ row:IndexPath,_ id:String) {
        
        
        let url = URL(string: url)
        
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "session") != nil)
            //if(true)
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
            
            let paramToSend = "id_pendidikan=" + id
            
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
                            self.pendidikan.remove(at: row.row)
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

class Pendidikan
{
    var id_education: String?
    var id_member: String?
    var degree: String?
    var univ_name: String?
    var major: String?
    var year_in: String?
    var year_out: String?
    var ipk: String?
    
    init(id_education: String, id_member: String, degree: String, univ_name: String, major: String, year_in: String, year_out: String, ipk: String)
    {
        self.id_education = id_education
        self.id_member = id_member
        self.degree = degree
        self.univ_name = univ_name
        self.major = major
        self.year_in = year_in
        self.year_out = year_out
        self.ipk = ipk
    }
    
}
