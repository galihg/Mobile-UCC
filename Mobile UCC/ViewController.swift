//
//  ViewController.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class ViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vacancy = [Vacancy]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.addSlideMenuButton()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        downloadAllVacancy()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Vacancy"
        self.navigationItem.title="Vacancy"
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "session") != nil ) {
           Auth.auth_check()
        }
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
            HUD.hide()
        }
        
    }
    
    /*override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }*/
    
    
    func downloadAllVacancy () {
        
        vacancy = []
        
        HUD.show(.progress)
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
                    
                    print(self.vacancy)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        HUD.hide()
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
        return vacancy.count
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
            let Vacancy2VC = segue.destination as! Vacancy2
            let pass = sender as! [Any]
            Vacancy2VC.passedData = pass
            navigationItem.title = nil
            
        }
    }
    
}



