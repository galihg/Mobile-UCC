//
//  ViewController.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vacancy = [Vacancy]()
    
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
        self.addSlideMenuButton()
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

        
        setLoadingScreen()
        downloadAllVacancy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        self.navigationController?.isNavigationBarHidden = false
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
    
    /*override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }*/
    
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
    
    func downloadAllVacancy () {
        
        vacancy = []
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/employers")
        
        //let defaults = UserDefaults.standard
        //if(defaults.object(forKey: "session") != nil)
        if(true)
        {
            
            //let preference_block = defaults.object(forKey: "session")
            //var preferences = preference_block as! [String]
            
            //let username = preferences[0]
            //let token = preferences[1]
            
            //let loginString = String(format: "%@:%@", username, token)
            //let loginData = loginString.data(using: String.Encoding.utf8)!
            //let base64LoginString = loginData.base64EncodedString()
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                /*if (error != nil) {
                    print("Error")
                }
                else {
                    do {
                        let jsonVacancy = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String:Any]
                        
                        for eachjsonVacancy in jsonVacancy{
                            let eachVacancy = eachjsonVacancy ["data"] as! [String:Any]
                            let company_name = eachVacancy ["offer_company"] as? String
                            let job_position = eachVacancy ["offer_name"] as? String
                            let id_vacancy = eachVacancy ["id_offer"] as? Int
                            
                            
                            // image URL
                            let company_logo = URL(string: eachVacancy ["offer_company_logo"] as! String)
                            
                            self.vacancy.append(Vacancy(company_name: company_name!, job_position: job_position!, company_logo: company_logo!, id_vacancy: id_vacancy!))
                        }
                        print (self.vacancy)
                    }
                    
                    catch {
                        print ("Error 2")
                    }
                }
            }*/
        

                
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
                            let vacancyDictionaries = server_response["data"] as! NSArray
                            //print(vacancyDictionaries)
                            for vacancyDictionary in vacancyDictionaries {
                                let eachVacancy = vacancyDictionary as! [String:Any]
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
        //return vacancy.count /*> 0 {
            return 1
        /*} else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Tidak ada lowongan"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }*/
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
            //var selectedRow = self.tableView.indexPathForSelectedRow
            let Vacancy2VC = segue.destination as! Vacancy2
            let pass = sender as! [Any]
            Vacancy2VC.passedData = pass
            navigationItem.title = nil
            
        }
    }
    
    /*func NewsAtIndexPath(IndexPath: NSIndexPath) -> News2 {
     let pass = news[IndexPath.section]
     return pass.news[IndexPath.row]
     }*/
    
}


class Vacancy
{
    var id_vacancy: Int?
    var company_name: String?
    var company_logo: URL?
    var total_vacancy: Int?
    var industry_type: String?
    
    init(company_name: String, id_vacancy: Int, company_logo: URL, total_vacancy: Int, industry_type: String)
    {
        self.company_name = company_name
        self.id_vacancy = id_vacancy
        self.company_logo = company_logo
        self.total_vacancy = total_vacancy
        self.industry_type = industry_type
        
    }
}
