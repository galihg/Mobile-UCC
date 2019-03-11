//
//  ProfileSummary.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 11/21/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class ProfileSummary: BaseViewController {

    @IBOutlet var profileSum: UITextView!
    @IBOutlet var addProfileSum: UIButton!
    @IBOutlet var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "edit"),for: UIControl.State())
        //add function for button
        button.addTarget(self, action: #selector(editButtonAction(sender:)), for: UIControl.Event.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        if (profileSum.text != "(empty)") {
            addProfileSum.isHidden = true
            profileSum.isHidden = false
        } else {
            profileSum.isHidden = true
            addProfileSum.isHidden = false
        }
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        self.title = "Profile Summary"
        ambilProfil()
    }
    
    func ambilProfil() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/shortprofile"
       
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let data_dictionary = server_response["data"] as? NSDictionary
                    let data = data_dictionary?["profil"] as? String ?? "(empty)"
                    
                    let passedData = data as String
                    
                    DispatchQueue.main.async {
                        self.profileSum.text = passedData
                        HUD.hide()
                    }
                } else if (status == "invalid-session") {
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
    
    @objc func editButtonAction(sender: UIBarButtonItem){
        let passedData = profileSum.text
        self.performSegue(withIdentifier: "showEditProfileSum", sender: passedData)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showEditProfileSum") {
            navigationItem.title = nil
            let Profile2VC = segue.destination as! EditProfileSummary
            let pass = sender as! String
            Profile2VC.passedData = pass
            
        }
        
    }

}
