//
//  ApplicationHistory.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 9/26/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class ApplicationHistory: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var history = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Application History"
        self.addSlideMenuButton()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        downloadAllHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    fileprivate func extractedFunc(_ controller: UIAlertController) {
        present(controller, animated: true, completion: nil)
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
            
            extractedFunc(controller)
        }
        
    }
    
    func downloadAllHistory () {
        HUD.show(.progress)
        history = []
        
        let url = "http://api.career.undip.ac.id/v1/applications/list"
  
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let historyDictionaries = server_response["data"] as! NSArray
                    
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

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if (self.history.count == 0){
                            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                            noDataLabel.text          = "Tidak ada riwayat lamaran"
                            noDataLabel.textColor     = UIColor.black
                            noDataLabel.textAlignment = .center
                            self.tableView.backgroundView  = noDataLabel
                            self.tableView.separatorStyle  = .none
                        }
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
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
        
        cancelApply(urlString4, indexPath!)
    }
    
    func cancelApply (_ url:String, _ row:IndexPath) {
        
        let url = url

        NetworkService.parseJSONFromURL(url, "DELETE", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.history.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        self.downloadAllHistory()
                    }
                } else if (status == "error") {
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
    }

}
