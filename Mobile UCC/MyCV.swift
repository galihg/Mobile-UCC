//
//  MyCV.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/27/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class MyCV: BaseViewController {

    
    @IBOutlet weak var profPic: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var emailProfile: UILabel!
    @IBOutlet weak var statusEmail: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    // View which contains the loading text and the spinner
    let loadingView = UIView()
    
    // Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        self.title = "My CV"
        
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "session") != nil)
        {
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [Any]
        
            profileName.text = (preferences[2] as! String)
            emailProfile.text = (preferences[3] as! String)
        
            let status = (preferences[5] as! Bool)
            if (status == true) {
                statusEmail.text = "(Verified)"
            }
            else {
                statusEmail.text = "(Unverified)"
            }
        
            let urlPicRaw = (preferences[4] as! String)
            let urlPic = URL (string: urlPicRaw)
            let networkService = NetworkService(url: urlPic!)
            networkService.downloadImage({ (imageData) in
                    let image = UIImage(data: imageData as Data)
                    DispatchQueue.main.async(execute: {
                        self.profPic.setImage(image, for: UIControlState())
                    })
                })
            
        }
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
    
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 30
        let height: CGFloat = 30
        let x = (contentView.frame.width / 2.3) - (width / 30.5)
        let y = (contentView.frame.height / 2.3) - (height / 2.3) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        
        contentView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }

    
    @IBAction func editPhoto(_ sender: Any) {
        let defaults = UserDefaults.standard
        let preference_block = defaults.object(forKey: "session")
        var preferences = preference_block as! [Any]
        
        let urlPic = (preferences[4] as! String)
        performSegue(withIdentifier: "showEditPhoto", sender: urlPic)
    
    }
    
    @IBAction func publicInfo(_ sender: Any) {

        let urlString = "http://api.career.undip.ac.id/v1/jobseekers/cv"
        
        setLoadingScreen()
        UIApplication.shared.beginIgnoringInteractionEvents()
        ambilCV(urlString)

    }
    
    @IBAction func showEdu(_ sender: Any) {
        performSegue(withIdentifier: "showEducation", sender: self)
    }
    
    func ambilCV (_ url: String) {
        
        let url = URL(string: url)
        let defaults = UserDefaults.standard
        let email = emailProfile.text
        let verifEmail = statusEmail.text
        
        
        if(defaults.object(forKey: "session") != nil)
        {
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [Any]
        
            let username = (preferences[0] as! String)
            let token = (preferences[1] as! String)
            let phone = (preferences[6] as! String)
            let verifPhone = (preferences[7] as! Bool)
            
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
                        let data_dictionary = server_response["data"] as? NSDictionary
                        let data1 = data_dictionary?["fullname"] as? String ?? "(empty)"
                        let data2 = data_dictionary?["academic_title"] as? String ?? "(empty)"
                        let data3 = data_dictionary?["birthdate"] as? String ?? "(empty)"
                        let data4 = data_dictionary?["birthplace"] as? String ?? "(empty)"
                        let data5 = data_dictionary?["gender"] as? String ?? "(empty)"
                        let data6 = data_dictionary?["religion"] as? String ?? "(empty)"
                        let data7 = data_dictionary?["marriage_status"] as? String ?? "(empty)"
                        let data8 = data_dictionary?["body_height"] as? Int ?? 0
                        let data9 = data_dictionary?["id_number"] as? String ?? "(empty)"
                        let data10 = data_dictionary?["current_address"] as? String ?? "(empty)"
                        let data11 = data_dictionary?["current_city"] as? String ?? "(empty)"
                        let data12 = data_dictionary?["current_province"] as? String ?? "(empty)"
                        let data13 = data_dictionary?["current_zip"] as? String ?? "(empty)"
                        let data14 = data_dictionary?["current_country"] as? String ?? "(empty)"
                        
                        let passedArray = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, email!, verifEmail!, phone, verifPhone] as [Any]
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showPublicInfo", sender: passedArray )
                        }
                        
                    }
             
                }
                
            })
            
            task.resume()
        }
    }
    
    @IBAction func profilSum(_ sender: Any) {
        let urlString = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/shortprofile"
        setLoadingScreen()
        UIApplication.shared.beginIgnoringInteractionEvents()
        ambilProfil(urlString)
    }
    
    func ambilProfil(_ url: String) {
        let url = URL(string: url)
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
                        let data_dictionary = server_response["data"] as? NSDictionary
                        let data = data_dictionary?["profil"] as? String ?? "(empty)"
                        
                        let passedData = data as String
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showProfileSum", sender: passedData )
                        }
                        
                    }
                    
                }
                
            })
            
            task.resume()
        }
    }
    
    
    @IBAction func showExperience(_ sender: Any) {
        performSegue(withIdentifier: "showWork", sender: self)
    }
    
    @IBAction func showLanguage(_ sender: Any) {
        performSegue(withIdentifier: "showLanguage", sender: self)
    }
    
    @IBAction func showEnglish(_ sender: Any) {
        let urlString = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/english"
        setLoadingScreen()
        UIApplication.shared.beginIgnoringInteractionEvents()
        ambilEnglish(urlString)
    }
    
    func ambilEnglish(_ url: String) {
        let url = URL(string: url)
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
                        let data_dictionary = server_response["data"] as? NSDictionary
                        let id_english = data_dictionary?["id_bhs_inggris"] as? String ?? "(empty)"
                        let id_member = data_dictionary?["id_member"] as? String ?? "(empty)"
                        let tipe_toefl = data_dictionary?["tipe_toefl"] as? String ?? "(empty)"
                        let nilai_toefl = data_dictionary?["nilai_toefl"] as? String ?? "(empty)"
                        let tahun_toefl = data_dictionary?["thn_toefl"] as? String ?? "(empty)"
                        let nilai_ielts = data_dictionary?["nilai_ielts"] as? String ?? "(empty)"
                        let tahun_ielts = data_dictionary?["thn_ielts"] as? String ?? "(empty)"
                        let nilai_toeic = data_dictionary?["nilai_toeic"] as? String ?? "(empty)"
                        let tahun_toeic = data_dictionary?["thn_toeic"] as? String ?? "(empty)"
                        
                        let passedArray = [id_english, id_member, tipe_toefl, nilai_toefl, tahun_toefl, nilai_ielts, tahun_ielts, nilai_toeic, tahun_toeic] as [String]
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showEnglish", sender: passedArray )
                        }
                        
                    }
                    
                }
                
            })
            
            task.resume()
        }
    }
    
    @IBAction func showOrganization(_ sender: Any) {
        performSegue(withIdentifier: "showOrganization", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditPhoto" {
            
            let PhotoVC = segue.destination as! EditPhoto
            let pass = sender as! String
            PhotoVC.passedData = pass
            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showPublicInfo" {
            
            removeLoadingScreen()
            UIApplication.shared.endIgnoringInteractionEvents()
            let PublicVC = segue.destination as! PublicInformation
            let pass = sender as! [Any]
            PublicVC.passedData = pass
            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showProfileSum" {
            
            removeLoadingScreen()
            UIApplication.shared.endIgnoringInteractionEvents()
            let ProfileVC = segue.destination as! ProfileSummary
            let pass = sender as! String
            ProfileVC.passedData = pass
            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showEducation" {
        
            let EduVC = segue.destination as! Education
            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showWork" {
            let WorkVC = segue.destination as! WorkExperience
            navigationItem.title = nil
        }
        
        if segue.identifier == "showLanguage" {
            navigationItem.title = nil
        }
        
        if segue.identifier == "showEnglish" {
            removeLoadingScreen()
            UIApplication.shared.endIgnoringInteractionEvents()
            let EnglishVC = segue.destination as! EnglishSkill
            let pass = sender as! [Any]
            EnglishVC.passedData = pass as! [String]
            navigationItem.title = nil
        }
    }
}
