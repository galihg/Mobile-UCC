//
//  ApplicationHistory.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 9/26/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class ApplicationHistory: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var history = [History]()
    
    // View which contains the loading text and the spinner
    let loadingView = UIView()
    
    // Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Application History"
        self.addSlideMenuButton()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        setLoadingScreen()
        downloadAllHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ViewControllers view ist fully loaded and could present further ViewController
        //Here you could do any other UI operations
        //tableView.reloadData()
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
    
    func downloadAllHistory () {
        
        history = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/applications/list")
        
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "session") != nil)
            //if(true)
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
                            let historyDictionaries = server_response["data"] as! NSArray
                            //print(vacancyDictionaries)
                            for historyDictionary in historyDictionaries {
                                let eachHistory = historyDictionary as! [String:Any]
                                let id_vacancy = eachHistory ["id_offer"] as? Int
                                let company_name = eachHistory ["offer_company"] as? String
                                let vacancy_name = eachHistory ["offer_name"] as? String
                                let tgl_apply = eachHistory ["date_apply"] as? String
                                let status_cancel = eachHistory ["cancelable"] as? Bool
                                let status_apply = eachHistory ["status"] as? Int
                                
                                // image URL
                                let company_logo = URL(string: eachHistory ["offer_company_logo"] as! String)
                                
                                self.history.append(History(company_name: company_name!, id_vacancy: id_vacancy!, company_logo: company_logo!, status_apply: status_apply!, vacancy_name: vacancy_name!, tgl_apply: tgl_apply!, status_cancel: status_cancel!))
                            }
                            print(self.history)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.removeLoadingScreen()
                            }
                            
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
        //if history.count != 0 {
        // return 1
        /*}
        else {
         let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
         noDataLabel.text          = "Tidak ada riwayat lamaran"
         noDataLabel.textColor     = UIColor.black
         noDataLabel.textAlignment = .center
         tableView.backgroundView  = noDataLabel
         tableView.separatorStyle  = .none
         return 0
        }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        /*if history.count == 0 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Tidak ada riwayat lamaran"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }*/
        
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! historyCell
        let history = self.history[indexPath.row]
        
        cell.history = history
        cell.btn_cancel.tag = indexPath.row
        cell.btn_cancel.addTarget(self, action: #selector(ApplicationHistory.cancel_apply(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func cancel_apply(_ sender: Any) {
        let data = history[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let vacancyId = data.id_vacancy
        let idString = "\(vacancyId!)"
        let urlString4 = "http://api.career.undip.ac.id/v1/applications/list/" + idString
        
        //setLoadingScreen()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        cancelApply(urlString4, indexPath!)
    }
    

    
    func cancelApply (_ url:String, _ row:IndexPath) {
        
        
        let url = URL(string: url)
        
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "session") != nil)
            //if(true)
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
            request.httpMethod = "DELETE"
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
                        let message = server_response["message"] as? String
                        self.createAlert(title: "WARNING!", message: message!)
                        DispatchQueue.main.async {
                            self.history.remove(at: row.row)
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
            
        else
        {
            self.openViewControllerBasedOnIdentifier("Login Screen")
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


class History
{
    var id_vacancy: Int?
    var company_name: String?
    var company_logo: URL?
    var vacancy_name: String?
    var tgl_apply: String?
    var status_apply: Int?
    var status_cancel: Bool?
    
    init(company_name: String, id_vacancy: Int, company_logo: URL, status_apply: Int, vacancy_name: String, tgl_apply: String, status_cancel: Bool)
    {
        self.company_name = company_name
        self.id_vacancy = id_vacancy
        self.company_logo = company_logo
        self.vacancy_name = vacancy_name
        self.tgl_apply = tgl_apply
        self.status_apply = status_apply
        self.status_cancel = status_cancel
        
    }
}

