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
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Skills"
        ambilSkill()
    }
    
    func ambilSkill() {
        HUD.show(.progress)
        let url =  "http://api.career.undip.ac.id/v1/jobseekers/cv_part/skill"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let data_dictionary = server_response["data"] as? NSDictionary
                    let id_keahlian = data_dictionary?["id_keahlian"] as? String ?? "(empty)"
                    let id_member = data_dictionary?["id_member"] as? String ?? "(empty)"
                    let teknis = data_dictionary?["teknis"] as? String ?? "(empty)"
                    let non_teknis = data_dictionary?["non_teknis"] as? String ?? "(empty)"
                    let komputer = data_dictionary?["komputer"] as? String ?? "(empty)"
                    let lainnya = data_dictionary?["lainnya"] as? String ?? "(empty)"
                    
                    DispatchQueue.main.async {
                        
                        self.teknis.text = teknis
                        self.nonteknis.text = non_teknis
                        self.komputer.text = komputer
                        self.other.text = lainnya
                        
                        if (self.teknis.text == "(empty)" && self.nonteknis.text == "(empty)" && self.komputer.text == "(empty)" && self.other.text == "(empty)" ) {
    
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
    

 

}
