//
//  EnglishSkill.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/24/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class EnglishSkill: BaseViewController {
    
    @IBOutlet var ContentView: [UILabel]!
    @IBOutlet var ImageView: [UIImageView]!
    
    @IBOutlet var toeflType: UILabel!
    @IBOutlet var toeflScore: UILabel!
    @IBOutlet var toeflYear: UILabel!
    @IBOutlet var ieltsScore: UILabel!
    @IBOutlet var ieltsYear: UILabel!
    @IBOutlet var toeicScore: UILabel!
    @IBOutlet var toeicYear: UILabel!

    let editButton = UIButton()
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.title = "English Skill"
         ambilEnglish()
    }
    
    
    func ambilEnglish() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/english"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
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
                    
                    
                    DispatchQueue.main.async {
                        
                        if tipe_toefl == "1" {
                            self.toeflType.text = "PBT (Paper-Based Test)"
                        } else if tipe_toefl == "2" {
                            self.toeflType.text = "CBT (Computer-Based Test)"
                        } else if tipe_toefl == "3" {
                            self.toeflType.text = "iBT (Internet-Based Test)"
                        } else {
                            self.toeflType.text = "(empty)"
                        }
                        
                        self.toeflScore.text = nilai_toefl
                        self.toeflYear.text = tahun_toefl
                        self.ieltsScore.text = nilai_ielts
                        self.ieltsYear.text = tahun_ielts
                        self.toeicScore.text = nilai_toeic
                        self.toeicYear.text = tahun_toeic
                        
                        HUD.hide()
                    }
                } else if (status == "invalid-session"){
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
        let passedArray = [toeflType.text!, toeflScore.text!, toeflYear.text!, ieltsScore.text!, ieltsYear.text!, toeicScore.text!, toeicYear.text!] as [String]
        performSegue(withIdentifier: "showEditEnglish", sender: passedArray)
    }
    
    private func setEditButton() {
        
        editButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        editButton.setBackgroundImage(UIImage(named: "edit2"), for: UIControl.State())
        editButton.addTarget(self, action: #selector(editEnglish), for: .touchUpInside)
        editButton.setTitle("         EDIT ENGLISH SKILL", for: [])
        self.view.addSubview(editButton)
    }
    
    private func removeEditButton() {
        editButton.isHidden = true
    }
    
    @objc func editEnglish(_ button: UIButton) {
        print("Button pressed 👍")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditEnglish" {
            let English2VC = segue.destination as! EditEnglishSkill
            let pass = sender as! [String]
            English2VC.passedData = pass
            navigationItem.title = nil 
        }
    }
    
    


}
