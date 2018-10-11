//
//  MyCV.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/27/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class MyCV: BaseViewController {

    
    @IBOutlet weak var profPic: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var emailProfile: UILabel!
    @IBOutlet weak var statusEmail: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
 
        let defaults = UserDefaults.standard
        if let preference_block = defaults.object(forKey: "session") {
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
        //self.navigationController?.isNavigationBarHidden = false
        
        self.title = "My CV"
        auth_check()
       
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
    
    func auth_check() {
        
        let url = "http://api.career.undip.ac.id/v1/auth/check"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String
            {
                if (status == "ok"){
                    
                    DispatchQueue.main.async {
                        return
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
    
    @IBAction func editPhoto(_ sender: Any) {
        let defaults = UserDefaults.standard
        let preference_block = defaults.object(forKey: "session")
        var preferences = preference_block as! [Any]
        
        let urlPic = (preferences[4] as! String)
        performSegue(withIdentifier: "showEditPhoto", sender: urlPic)
    
    }
    
    @IBAction func publicInfo(_ sender: Any) {
        performSegue(withIdentifier: "showPublicInfo", sender: self )
    }
    
    @IBAction func showEdu(_ sender: Any) {
        performSegue(withIdentifier: "showEducation", sender: self)
    }
    
    @IBAction func profilSum(_ sender: Any) {
        performSegue(withIdentifier: "showProfileSum", sender: self )
    }
    
    @IBAction func showExperience(_ sender: Any) {
        performSegue(withIdentifier: "showWork", sender: self)
    }
    
    @IBAction func showLanguage(_ sender: Any) {
        performSegue(withIdentifier: "showLanguage", sender: self)
    }
    
    @IBAction func showEnglish(_ sender: Any) {
        self.performSegue(withIdentifier: "showEnglish", sender: self )
    }
   
    @IBAction func showOrganization(_ sender: Any) {
        performSegue(withIdentifier: "showOrganization", sender: self)
    }
    
    @IBAction func showAward(_ sender: Any) {
        performSegue(withIdentifier:"showAward" , sender: self)
    }
    
    @IBAction func showRecommendation(_ sender: Any) {
        performSegue(withIdentifier:"showRecommendation" , sender: self)
        
    }
    
    @IBAction func showStrength(_ sender: Any) {
        performSegue(withIdentifier: "showStrength", sender: self )
    }
    
    @IBAction func showSkill(_ sender: Any) {
        performSegue(withIdentifier: "showSkill", sender: self )
    }
    
    @IBAction func showCTC(_ sender: Any) {
        performSegue(withIdentifier: "showCTC", sender: self)
    }
    
    @IBAction func showPortofolio(_ sender: Any) {
        performSegue(withIdentifier: "showPortofolio", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditPhoto" {
            
            let PhotoVC = segue.destination as! EditPhoto
            let pass = sender as! String
            PhotoVC.passedData = pass
            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showPublicInfo" {

            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showProfileSum" {
            
            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showEducation" {
  
            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showWork" {
          
            navigationItem.title = nil
        }
        
        if segue.identifier == "showLanguage" {
            navigationItem.title = nil
        }
        
        if segue.identifier == "showEnglish" {
            navigationItem.title = nil
        }
        
        if segue.identifier == "showOrganization" {
            navigationItem.title = nil
        }
        
        if segue.identifier == "showAward" {
            navigationItem.title = nil
        }
        
        if segue.identifier == "showRecommendation" {
            navigationItem.title = nil
        }
        
        if segue.identifier == "showStrength" {

            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showSkill" {

            navigationItem.title = nil
            
        }
        
        if segue.identifier == "showCTC" {
            navigationItem.title = nil
        }
        
        if segue.identifier == "showPortofolio" {
            navigationItem.title = nil
        }
        
    }
}
