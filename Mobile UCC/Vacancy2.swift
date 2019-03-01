//
//  Vacancy2.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/22/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class Vacancy2: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var namaPerusahaan: UILabel!
    @IBOutlet weak var imgPerusahaan: UIButton!
    @IBOutlet weak var totalLowongan: UILabel!
    @IBOutlet weak var tableView: UITableView!
  
    var detailVacancy = [DetailVacancy]()
  
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      
        let passedURL = passedData[1]
        
        let networkService = NetworkService(url: passedURL as! URL)
        networkService.downloadImage({ (imageData) in
            let image = UIImage(data: imageData as Data)
            DispatchQueue.main.async(execute: {
                self.imgPerusahaan.setImage(image, for: UIControl.State())
            })
        })
        
        namaPerusahaan.text = (passedData[2] as! String)
        
        let passedInt = passedData[3]
        totalLowongan.text = "\(passedInt)" + " Lowongan"
        
        //Bagian tabel
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    
        downloadAllDetailVacancy()
        
        imgPerusahaan.contentMode = .center
        imgPerusahaan.imageView?.contentMode = .scaleAspectFit
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
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
    
    func downloadAllDetailVacancy () {
        
        detailVacancy = []
        
        let passedInt2 = passedData [0]
        let Id = "\(passedInt2)"
        
        let url = "http://api.career.undip.ac.id/v1/employers/detail/" + Id
        
        HUD.show(.progress)
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                
                if (status == "ok") {
                    
                    let rawvacancy2Dictionaries = server_response["data"] as! [String:Any]
                    let vacancy2Dictionaries = rawvacancy2Dictionaries["vacancies"] as! NSArray
                    
                    for vacancy2Dictionary in vacancy2Dictionaries {
                        let eachVacancy = vacancy2Dictionary as! [String:Any]
                        
                        let id_vacancy = eachVacancy["id"] as? String
                        let total_applicants = eachVacancy["applicants"] as?
                        Int
                        let remaining_days = eachVacancy["valid_days"] as? Int ?? 0
                        let vacancy_name = eachVacancy["name"] as? String
                        let deadline = eachVacancy["deadline"] as? String ?? "nil"
                        
                        
                        let apply_online = eachVacancy["allow_apply_online"] as? Bool
                        
                        let eachVacancy6 = eachVacancy["position_category"] as! [String:Any]
                        let job_position = eachVacancy6["label"] as? String
                        
                        let eachVacancy3 = eachVacancy["education"] as! [String:Any]
                        let min_education = eachVacancy3["label"] as? String
                        
                        let eachVacancy4 = eachVacancy["vacancy_type"] as! [String:Any]
                        let type_vacancy = eachVacancy4["label"] as? String
                        
                        let eachVacancy5 = eachVacancy["placement"] as! [String:Any]
                        let assignment = eachVacancy5["label"] as? String ?? "nil"
                        
                        self.detailVacancy.append(DetailVacancy(id_vacancy: id_vacancy!, total_applicants: total_applicants!, remaining_days: remaining_days, vacancy_name: vacancy_name!, deadline: deadline, apply_online: apply_online!, job_position: job_position!, min_education: min_education!, type_vacancy: type_vacancy!, assignment: assignment))
                    }
                   
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                    
                } 
            }
        }
            
    
    }
    
    func LoginError() {
        self.openViewControllerBasedOnIdentifier("Login Screen")
    }
    
    @IBAction func getPerusahaan(_ sender: Any) {
        ambilPerusahaan()
    }

    func ambilPerusahaan () {
        
        let id_perusahaan = passedData [0]
        let idString = "\(id_perusahaan)"
        
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/employers/detail/" + idString
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok") {
                    let data1 = server_response["data"] as? NSDictionary
                    let data2 = data1?["address"] as? String
                    let data3 = data1?["profile_html"] as? String
                    let data4 = data1?["company_contact"] as? String
                    let data5 = data1?["website"] as? String ?? "nil"
                    let data6 = self.passedData[1]
                    let data7 = self.passedData[2]
                    
                    let passedArray = [data2!, data3!, data4!, data5, data6, data7] as [Any]
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "detailCompany", sender: passedArray )
                    }
                    
                }
            }
                
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCompany" {
        
            HUD.hide()
            let CompanyVC = segue.destination as! CompanyInfo
            let pass = sender as! [Any]
            CompanyVC.passedData = pass
            navigationItem.title = nil
            
        } else if segue.identifier == "detailVacancy" {
           
            HUD.hide()
            let Vacancy3VC = segue.destination as! Vacancy3
            let pass = sender as! [Any]
            Vacancy3VC.passedData = pass
            navigationItem.title = nil
            
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
        return detailVacancy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vacancy2Cell", for: indexPath) as! vacancy2Cell
        let detailVacancy = self.detailVacancy[indexPath.row]
        
        cell.detailVacancy = detailVacancy
        cell.detailPass.tag = indexPath.row
        cell.detailPass.addTarget(self, action: #selector(Vacancy2.buttonPass(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func buttonPass(_ sender: Any) {
        let data = detailVacancy[(sender as AnyObject).tag]
        
        let vacancyId = data.id_vacancy
        let idString = "\(vacancyId!)"
        let urlString3 = "http://api.career.undip.ac.id/v1/vacancies/detail/" + idString
        
       
        ambilVacancy(urlString3, vacancyId!)
        
        
    }
    
    func ambilVacancy (_ url:String, _ id:String) {
        
        HUD.show(.progress)
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    let data1 = server_response["data"] as? NSDictionary
                    let jobName = data1?["name"] as? String
                    
                    let data2 = server_response["employer_data"] as? NSDictionary
                    let companyName = data2?["name"] as? String
                    
                    let totalApplicants = data1?["applicants"] as? Int ?? 0
                    
                    let data3 = data1?["position_category"] as? NSDictionary
                    let jobPosition = data3?["label"] as? String ?? "nil"
                    
                    let jobDeadline = data1?["deadline"] as? String ?? "nil"
                    
                    let data4 = data1?["education"] as? NSDictionary
                    let jobEducation = data4?["label"] as? String ?? "nil"
                    
                    let data5 = data1?["vacancy_type"] as? NSDictionary
                    let jobType = data5?["label"] as? String ?? "nil"
                    
                    let data6 = data1?["placement"] as? NSDictionary
                    let jobPlacement = data6?["label"] as? String ?? "nil"
                    
                    let jobApply = data1?["allow_apply_online"] as? Bool ?? false
                    let jobClosed = data1?["closed"] as? Bool ?? false
                    let jobPublished = data1?["date_published"] as? String ?? "nil"
                    let jobValid = data1?["valid_days"] as? Int ?? 0
                    let globalReq = data1?["global_requirement_html"] as? String ?? "nil"
                    let specialReq = data1?["special_requirement_html"] as? String ?? "nil"
                    let jobInfo = data1?["more_information_html"] as? String ?? "nil"
                    
                    
                    let passedArray = [jobName!, companyName!, totalApplicants, jobPosition, jobDeadline, jobEducation, jobType, jobPlacement, jobApply, jobClosed, jobPublished, jobValid, globalReq, specialReq, jobInfo, id] as [Any]
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "detailVacancy", sender: passedArray )
                    }
                }
            }
            
        }
        
 
    }
    

}


