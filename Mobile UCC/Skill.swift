//
//  Skill.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 09/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class Skill: BaseViewController {

    @IBOutlet weak var technicalLabel: UILabel!
    @IBOutlet weak var blueLine: UIImageView!
    @IBOutlet weak var blueLine2: UIImageView!
    @IBOutlet weak var blueLine3: UIImageView!
    @IBOutlet weak var blueLine4: UIImageView!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var teknis: UITextView!
    @IBOutlet weak var nontechnicalLabel: UILabel!
    @IBOutlet weak var nonteknis: UITextView!
    @IBOutlet weak var computerLabel: UILabel!
    @IBOutlet weak var komputer: UITextView!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var other: UITextView!
    
    var passedData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        self.title = "Skills"
        self.navigationItem.title="Skills"
        ambilSkill()
    }
    
    func ambilSkill() {
        HUD.show(.progress)
        let url =  "http://api.career.undip.ac.id/v1/jobseekers/cv_part/skill"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let data_dictionary = server_response["data"] as? NSDictionary
                    let id_keahlian = data_dictionary?["id_keahlian"] as? String ?? ""
                    let id_member = data_dictionary?["id_member"] as? String ?? ""
                    let teknis = data_dictionary?["teknis"] as? String ?? ""
                    let non_teknis = data_dictionary?["non_teknis"] as? String ?? ""
                    let komputer = data_dictionary?["komputer"] as? String ?? ""
                    let lainnya = data_dictionary?["lainnya"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        
                        self.teknis.text = teknis
                        self.nonteknis.text = non_teknis
                        self.komputer.text = komputer
                        self.other.text = lainnya
                        
                        if (self.teknis.text == "" && self.nonteknis.text == "" && self.komputer.text == "" && self.other.text == "" ) {
    
                            self.setSubview(true)
                            HUD.hide()
                            
                        } else {
  
                            self.setSubview(false)
                            HUD.hide()
                            
                        }
                        
                    }
                } else if (status == "invalid-session"){
                    
                    let preferences = UserDefaults.standard
                    preferences.removeObject(forKey: "session")
                    
                    DispatchQueue.main.async {
                        self.openViewControllerBasedOnIdentifier("Home")
                        Alert.showMessage(title: "WARNING!", msg: "Sesi Login telah berakhir, silahkan login ulang")
                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                        NotificationCenter.default.post(name: .reload, object: nil)
                    }
                }
            }
        }
    }
    
    func setSubview(_ status: Bool){
        technicalLabel.isHidden = status
        blueLine.isHidden = status
        blueLine2.isHidden = status
        blueLine3.isHidden = status
        blueLine4.isHidden = status
        teknis.isHidden = status
        nontechnicalLabel.isHidden = status
        nonteknis.isHidden = status
        computerLabel.isHidden = status
        komputer.isHidden = status
        otherLabel.isHidden = status
        other.isHidden = status
        
        if (status == true){
            btn_edit.isHidden = false
        } else {
            btn_edit.isHidden = true
        }
    }
    
    @objc func editButtonAction(sender: UIBarButtonItem){
        let technical = teknis.text!
        let nonTechnical = nonteknis.text
        let computer = komputer.text
        let otherSkill = other.text
        
        let passedArray = [technical, nonTechnical, computer, otherSkill]
        performSegue(withIdentifier: "showEditSkill", sender: passedArray)
    }
    
    @IBAction func editSkill(_ sender: Any) {
        let technical = teknis.text!
        let nonTechnical = nonteknis.text
        let computer = komputer.text
        let otherSkill = other.text
        
        let passedArray = [technical, nonTechnical, computer, otherSkill]
        performSegue(withIdentifier: "showEditSkill", sender: passedArray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditSkill" {
            let Skill2VC = segue.destination as! EditSkill
            let pass = sender as! [String]
            Skill2VC.passedData = pass
            navigationItem.title = nil
        }
    }

}
