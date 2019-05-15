//
//  ViewController.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class EmployerList: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vacancy = [Vacancy]()
    //var refresher: UIRefreshControl!
    //var refreshControl = RefreshControl()
    //var refreshView = refreshControl.refresher
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.addSlideMenuButton()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        //getRefreshcontrol()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
        self.title = "Vacancy"
        self.navigationItem.title = "Vacancy"
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "session") != nil ) {
           Auth.auth_check()
        }
        
        downloadAllVacancy("load")
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
            Alert.showMessage(title: "No Internet Detected", msg: "This app requires an Internet connection")
         
            HUD.hide()
        }
    }
    
    /*func getRefreshcontrol() {
        //let refreshView = refreshControl.refresher
        //refreshView.addTarget(self, action: #selector(populate), for: .valueChanged)
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Loading...")
        refresher.addTarget(self, action: #selector(populate), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
    }
    
    @objc func populate() {
        //downloadAllVacancy("refresh")
        
        if Reachability.isConnectedToNetwork() == true
        {
            downloadAllVacancy("refresh")
        }
        else
        {
            Alert.showMessage(title: "No Internet Detected", msg: "This app requires an Internet connection")
            
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "Tidak ada lowongan pekerjaan"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            
            refresher.endRefreshing()
            //HUD.hide()
        }
    }*/
    
    func emptyView(_ state: Bool) {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        noDataLabel.text          = "No Vacancy"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        
        if state == true {
            self.tableView.backgroundView  = noDataLabel
            self.tableView.separatorStyle  = .none
        } else {
            self.tableView.backgroundView?.isHidden = true
            self.tableView.separatorStyle  = .singleLine
        }
    }
    
    func downloadAllVacancy(_ loadType: String) {
        //let refreshView = refreshControl.refresher
        vacancy = []
        HUD.show(.progress)
        /*if (loadType != "refresh") {
            HUD.show(.progress)
        }*/
        
        let url = "http://api.career.undip.ac.id/v1/employers"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    let vacancyDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for vacancyDictionary in vacancyDictionaries {
                        let eachVacancy = vacancyDictionary
                        let id_vacancy = eachVacancy ["id"] as? Int
                        let company_name = eachVacancy ["name"] as? String
                        
                        let eachVacancy2 = eachVacancy ["vacancies_stat"] as! [String:Any]
                        let total_vacancy = eachVacancy2 ["open"] as? Int
                        
                        let eachVacancy3 = eachVacancy ["industry"] as! [String:Any]
                        let industry_type = eachVacancy3 ["label"] as? String
                        
                        // image URL
                        let company_logo = URL(string: eachVacancy ["logo"] as! String)
                        
                    self.vacancy.append(Vacancy(company_name: company_name!, id_vacancy: id_vacancy!, company_logo: company_logo!, total_vacancy: total_vacancy!, industry_type: industry_type!))
                    }
                    
                    self.tableView.reloadData()
                    HUD.hide()
                    
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
        if vacancy.count > 0 {
            emptyView(false)
            return vacancy.count
        } else {
            emptyView(true)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vacancyCell", for: indexPath) as! vacancyCell
        let vacancy = self.vacancy[indexPath.row]
        cell.vacancy = vacancy

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vacancy = self.vacancy[indexPath.row]
        let vacancyId = vacancy.id_vacancy
        let companyLogo = vacancy.company_logo
        let companyName = vacancy.company_name
        let totalVacancy = vacancy.total_vacancy
        
        
        let passedArray = [vacancyId!, companyLogo!, companyName!, totalVacancy!] as [Any]
        performSegue(withIdentifier: "passVacancy", sender: passedArray )
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passVacancy" {
            let VacancyListVC = segue.destination as! VacancyList
            let pass = sender as! [Any]
            VacancyListVC.passedData = pass
            navigationItem.title = nil
            
        }
    }
    
}



