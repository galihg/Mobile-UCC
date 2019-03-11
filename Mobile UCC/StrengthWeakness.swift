//
//  StrengthWeakness.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 08/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

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
                    let id_karakter = data_dictionary?["id_karakter"] as? String ?? ""
                    let id_member = data_dictionary?["id_member"] as? String ?? ""
                    let kelebihan = data_dictionary?["kelebihan"] as? String ?? ""
                    let kekurangan = data_dictionary?["kekurangan"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self.kelebihan.text = kelebihan
                        self.kekurangan.text = kekurangan
                        
                        if (self.kelebihan.text == "" && self.kekurangan.text == "") {
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
        let strength = kelebihan.text
        let weakness = kekurangan.text
        
        let passedArray = [strength, weakness]
        performSegue(withIdentifier: "showEditStrengthWeakness", sender: passedArray)
    }
    
    @IBAction func editStrengthWeakness(_ sender: Any) {
        let strength = kelebihan.text
        let weakness = kekurangan.text
        
        let passedArray = [strength, weakness]
        performSegue(withIdentifier: "showEditStrengthWeakness", sender: passedArray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditStrengthWeakness" {
            let SW2VC = segue.destination as! EditStrengthWeakness
            let pass = sender as! [String]
            SW2VC.passedData = pass
            navigationItem.title = nil 
        }
    }
    
    
}
