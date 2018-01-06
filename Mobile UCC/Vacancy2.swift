//
//  Vacancy2.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/22/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit


class Vacancy2: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var namaPerusahaan: UILabel!
    @IBOutlet weak var imgPerusahaan: UIButton!
    @IBOutlet weak var totalLowongan: UILabel!
    @IBOutlet weak var tableView: UITableView!
  
    var detailVacancy = [DetailVacancy]()
 
    
    var passedData : [Any] = []
    
    
    // View which contains the loading text and the spinner
    let loadingView = UIView()
    
    // Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Vacancy"
        let passedURL = passedData[1]
        
        let networkService = NetworkService(url: passedURL as! URL)
        networkService.downloadImage({ (imageData) in
            let image = UIImage(data: imageData as Data)
            DispatchQueue.main.async(execute: {
                self.imgPerusahaan.setImage(image, for: UIControlState())
            })
        })
        
        namaPerusahaan.text = (passedData[2] as! String)
        
        let passedInt = passedData[3]
        totalLowongan.text = "\(passedInt)" + " Lowongan"
        
        //Bagian tabel
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        let passedInt2 = passedData [0]
        let Id = "\(passedInt2)"
        
        let urlString = "http://api.career.undip.ac.id/v1/employers/detail/" + Id
        
        
        setLoadingScreen()
        downloadAllDetailVacancy(urlString)
        
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
    
    
    func downloadAllDetailVacancy (_ url:String) {
        
        detailVacancy = []
        
        let url = URL(string: url)
        
        //let defaults = UserDefaults.standard
        //if(defaults.object(forKey: "session") != nil)
        if(true)
        {
            /*let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
            
            let username = preferences[0]
            let token = preferences[1]
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()*/
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
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
                        do {
                            let rawvacancy2Dictionaries = server_response["data"] as! [String:Any]
                            let vacancy2Dictionaries = rawvacancy2Dictionaries["vacancies"] as! NSArray
                            //print(vacancyDictionaries)
                            for vacancy2Dictionary in vacancy2Dictionaries {
                                let eachVacancy = vacancy2Dictionary as! [String:Any]
                                //let eachVacancy2 = eachVacancy["vacancies"] as! [String:Any]
                                
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
                            print(self.detailVacancy)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.removeLoadingScreen()
                            }
                        }
                        
                    }
                    /*else if (data_block=="invalid-session"){
                        DispatchQueue.main.async (
                            execute:self.LoginError
                        )
                    }*/
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
    
    @IBAction func getPerusahaan(_ sender: Any) {
        let id_perusahaan = passedData [0]
        let idString = "\(id_perusahaan)"
        
        let urlString2 = "http://api.career.undip.ac.id/v1/employers/detail/" + idString
        
        setLoadingScreen()
        UIApplication.shared.beginIgnoringInteractionEvents()
        ambilPerusahaan(urlString2)
        
    }

    func ambilPerusahaan (_ url:String) {
        
        let url = URL(string: url)
        
        //let defaults = UserDefaults.standard
        //if(defaults.object(forKey: "session") != nil)
        if(true)
        {
            /*let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
            
            let username = preferences[0]
            let token = preferences[1]
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()*/
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
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
                    /*else if (data_block=="invalid-session"){
                        DispatchQueue.main.async (
                            execute:self.LoginError
                        )
                    }*/
                }
                
            })
            
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCompany" {
        
            removeLoadingScreen()
            UIApplication.shared.endIgnoringInteractionEvents()
            let CompanyVC = segue.destination as! CompanyInfo
            let pass = sender as! [Any]
            CompanyVC.passedData = pass
            navigationItem.title = nil
            
        } else if segue.identifier == "detailVacancy" {
           
            removeLoadingScreen()
            UIApplication.shared.endIgnoringInteractionEvents()
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
        return detailVacancy.count /*> 0 {
            return 1
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Detail lowongan tidak ditemukan"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }*/
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
        
        setLoadingScreen()
        UIApplication.shared.beginIgnoringInteractionEvents()
        ambilVacancy(urlString3, vacancyId!)
        
        /* let deadlineVacancy = data.deadline
        let jobPosition = data.job_position
        let min_education = data.min_education
        let vacancy_type = data.type_vacancy
        let placement = data.assignment
        let total_applicants = data.total_applicants
        let apply_online = data.apply_online*/
        
        //let passedArray = [vacancyId!, deadlineVacancy!, jobPosition!, min_education!, vacancy_type!, placement!, total_applicants!, apply_online!] as [Any]
        
    }
    
    func ambilVacancy (_ url:String, _ id:String) {
        
        let url = URL(string: url)
        
        //let defaults = UserDefaults.standard
        //if(defaults.object(forKey: "session") != nil)
        if(true)
        {
            /*let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
             
            let username = preferences[0]
            let token = preferences[1]
             
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()*/
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
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
    

}

class DetailVacancy
    
{
    var id_vacancy: String?
    var total_applicants: Int?
    var remaining_days: Int?
    var vacancy_name: String?
    var deadline: String?
    var apply_online: Bool?
    var job_position: String?
    var min_education: String?
    var type_vacancy: String?
    var assignment: String?
    
    init(id_vacancy: String, total_applicants: Int, remaining_days: Int, vacancy_name: String, deadline: String, apply_online: Bool, job_position: String, min_education: String, type_vacancy: String, assignment: String)
    {
        self.id_vacancy = id_vacancy
        self.total_applicants = total_applicants
        self.remaining_days = remaining_days
        self.vacancy_name = vacancy_name
        self.deadline = deadline
        self.apply_online = apply_online
        self.job_position = job_position
        self.min_education = min_education
        self.type_vacancy = type_vacancy
        self.assignment = assignment
        
    }
}
