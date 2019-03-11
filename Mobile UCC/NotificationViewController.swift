//
//  NotificationViewController.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 9/4/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class NotificationViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var notifikasi = [Notifikasi]()
    
    let url = URL(string: "http://api.career.undip.ac.id/v1/auth/check")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
        self.title = "Notification"
        downloadAllNotification()
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
    
    func downloadAllNotification () {
        
        notifikasi = []
        
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/notification"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let notificationDictionaries = server_response["data"] as! NSArray
                    
                    for notificationDictionary in notificationDictionaries {
                        let eachNotification = notificationDictionary as! [String:Any]
                        let id_notif = eachNotification ["id"] as? Int
                        let type_notif = eachNotification ["type"] as? String
                        let subject_notif = eachNotification ["subject"] as? String
                        let status = eachNotification ["read"] as? Bool
                        let date_notif = eachNotification ["date_created"] as? String
                        
                        self.notifikasi.append(Notifikasi(id_notif: id_notif!, type_notif: type_notif!, subject_notif: subject_notif!, status: status!, date_notif: date_notif!))
                    }
                  
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                    
                } else if (status == "invalid-session"){
                    let keychain = KeychainSwift()
                    let preferences = UserDefaults.standard
                    
                    keychain.clear()
                    preferences.removeObject(forKey: "session")
                    
                    DispatchQueue.main.async {
                        self.openViewControllerBasedOnIdentifier("Home")
                        Alert.showMessage(title: "WARNING!", msg: "Login session has ended, please login again")
                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                        NotificationCenter.default.post(name: .reload, object: nil)
                    }
                }
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if notifikasi.count > 0 {
            return notifikasi.count
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Notification"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifCell", for: indexPath) as! notifCell
        let notifikasi = self.notifikasi[indexPath.row]
        
        cell.notifikasi = notifikasi
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notification = self.notifikasi[indexPath.row]
        let notifId = notification.id_notif

        downloadDetailNotif(notifId!)
    }
    
    func downloadDetailNotif (_ notifId: Int) {
        
        HUD.show(.progress)
        let idString = "\(notifId)"
        let url = "http://api.career.undip.ac.id/v1/jobseekers/notification/" + idString
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
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
                else if (status == "invalid-session"){
                    let keychain = KeychainSwift()
                    let preferences = UserDefaults.standard
                    
                    keychain.clear()
                    preferences.removeObject(forKey: "session")
                    
                    Alert.showMessage(title: "WARNING!", msg: session_end_message)
                    
                    DispatchQueue.main.async {
                        self.openViewControllerBasedOnIdentifier("Home")

                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                        NotificationCenter.default.post(name: .reload, object: nil)
                    }
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailNotif" {
            HUD.hide()
            let Notif2VC = segue.destination as! DetailNotif
            let pass = sender as! [Any]
            Notif2VC.passedData = pass
            navigationItem.title = nil
        }
    }
    
}

