//
//  NotificationViewController.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 9/4/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // View which contains the loading text and the spinner
    let loadingView = UIView()
    
    // Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    var notification = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        self.title = "Notification"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        
        /*Vacancy.downloadAllVacancy(completionHandler: { (Vacancy) in
         let vacancy = Vacancy as NSArray
         DispatchQueue.main.async(execute: {
         self.vacancy = vacancy as! [Vacancy]
         })
         })*/
        
        downloadAllNotification()
        setLoadingScreen()
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
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 30
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2.3) - (width / 30.5)
        let y = (tableView.frame.height / 2.3) - (height / 2.3) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
    
    func downloadAllNotification () {
        
        notification = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/jobseekers/notification")
        
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
                            let notificationDictionaries = server_response["data"] as! NSArray
                            //print(vacancyDictionaries)
                            for notificationDictionary in notificationDictionaries {
                                let eachNotification = notificationDictionary as! [String:Any]
                                let id_notif = eachNotification ["id"] as? Int
                                let type_notif = eachNotification ["type"] as? String
                                let subject_notif = eachNotification ["subject"] as? String
                                let status = eachNotification ["read"] as? Bool
                                let date_notif = eachNotification ["date_created"] as? String
                                
                                self.notification.append(Notification(id_notif: id_notif!, type_notif: type_notif!, subject_notif: subject_notif!, status: status!, date_notif: date_notif!))
                            }
                            print(self.notification)
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
        if notification.count > 0 {
            return 1
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Tidak ada Notifikasi"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifCell", for: indexPath) as! notifCell
        let notification = self.notification[indexPath.row]
        
        cell.notification = notification
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notification = self.notification[indexPath.row]
        let notifId = notification.id_notif
        let idString = "\(notifId!)"
        
        let urlString = "http://api.career.undip.ac.id/v1/jobseekers/notification/" + idString
        setLoadingScreen()
        UIApplication.shared.beginIgnoringInteractionEvents()
        downloadDetailNotif(urlString)
    }
    
    func downloadDetailNotif (_ url: String) {
        
        
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
                        let notificationDictionaries = server_response["data"] as! NSDictionary
                        let type_notif = notificationDictionaries["type"] as? String
                        let subject_notif = notificationDictionaries ["subject"] as? String
                        let date_notif = notificationDictionaries ["date_created"] as? String
                        let content_notif = notificationDictionaries ["content_html"] as? String
                        
                        let passedArray = [type_notif!, subject_notif!, date_notif!, content_notif!] as [Any]
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "detailNotif", sender: passedArray )
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailNotif" {
            //var selectedRow = self.tableView.indexPathForSelectedRow
            removeLoadingScreen()
            UIApplication.shared.endIgnoringInteractionEvents()
            let Notif2VC = segue.destination as! DetailNotif
            let pass = sender as! [Any]
            Notif2VC.passedData = pass
            navigationItem.title = nil
            
        }
    }
    
    /*func NewsAtIndexPath(IndexPath: NSIndexPath) -> News2 {
     let pass = news[IndexPath.section]
     return pass.news[IndexPath.row]
     }*/
    
}

class Notification
{
    var id_notif: Int?
    var type_notif: String?
    var subject_notif: String?
    var status: Bool?
    var date_notif: String?
    
    init(id_notif: Int, type_notif: String, subject_notif: String, status: Bool, date_notif: String)
    {
        self.id_notif = id_notif
        self.type_notif = type_notif
        self.subject_notif = subject_notif
        self.status = status
        self.date_notif = date_notif
        
    }
}
