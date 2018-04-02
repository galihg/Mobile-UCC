//
//  StrengthWeakness.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 08/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class StrengthWeakness: BaseViewController {

    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var blueLine: UIImageView!
    @IBOutlet weak var weaknessLabel: UILabel!
    @IBOutlet weak var kelebihan: UITextView!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var kekurangan: UITextView!
    @IBOutlet weak var blueLine2: UIImageView!
    
    var passedData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "edit"),for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(editButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Strength and Weakness"
        ambilCharacter()
    }
    
    func ambilCharacter() {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/character"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String{
                if (status == "ok"){
                    let data_dictionary = server_response["data"] as? NSDictionary
                    let id_karakter = data_dictionary?["id_karakter"] as? String ?? "(empty)"
                    let id_member = data_dictionary?["id_member"] as? String ?? "(empty)"
                    let kelebihan = data_dictionary?["kelebihan"] as? String ?? "(empty)"
                    let kekurangan = data_dictionary?["kekurangan"] as? String ?? "(empty)"
                    
                    DispatchQueue.main.async {
                        self.kelebihan.text = kelebihan
                        self.kekurangan.text = kelebihan
                        
                        if (self.kelebihan.text == "(empty)" && self.kekurangan.text == "(empty)") {
                            self.strengthLabel.isHidden = true
                            self.blueLine.isHidden = true
                            self.kelebihan.isHidden = true
                            self.weaknessLabel.isHidden = true
                            self.kekurangan.isHidden = true
                            self.blueLine2.isHidden = true
                            self.btn_edit.isHidden = false
                        } else {
                            self.btn_edit.isHidden = true
                        }
                        
                        HUD.hide()
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
    
    func editButtonAction(sender: UIBarButtonItem){
        
    }
}
