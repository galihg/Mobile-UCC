//
//  PublicInformation.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 11/8/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class PublicInformation: BaseViewController {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var jobseekerTitle: UILabel!
    @IBOutlet weak var tglLahir: UILabel!
    @IBOutlet weak var tmpatLahir: UILabel!
    @IBOutlet weak var jenisKelamin: UILabel!
    @IBOutlet weak var agama: UILabel!
    @IBOutlet weak var maritalStatus: UILabel!
    @IBOutlet weak var tinggiBadan: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id_number: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var province: UILabel!
    @IBOutlet weak var zip_code: UILabel!
    @IBOutlet weak var country: UILabel!

    var verifNumber : String!
    
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
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Basic Information"
        ambilCV()
    }
    
    func ambilCV () {
        HUD.show(.progress)
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv"
        
        let defaults = UserDefaults.standard
        
        if let preference_block = defaults.object(forKey: "session") {
            let preferences = preference_block as! [Any]
            let phone = preferences[6] as! String
            let verifPhone = preferences[7] as! Bool
            let email = preferences[3] as! String
            let verifEmail = preferences[5] as! Bool
            
            NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
                
                if let status = server_response["status"] as? String {
                    if (status == "ok"){
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

                        DispatchQueue.main.async {
                            
                            //isi Public Information
                            self.fullName.text = data1
                            self.jobseekerTitle.text = data2
                            self.tglLahir.text = data3
                            self.tmpatLahir.text = data4
                            self.jenisKelamin.text = data5
                            self.agama.text = data6
                            self.maritalStatus.text = data7
                            
                            if (data8 == 0) {
                                self.tinggiBadan.text = "(empty)"
                            } else {
                                self.tinggiBadan.text = "\(data8)"
                            }
                            
                            if (verifPhone == true ) {
                                self.verifNumber = "(Verified)"
                            } else {
                                self.verifNumber = "(Unverified)"
                            }
                            
                            if (self.phoneNumber.text == "(Empty)") {
                                self.phoneNumber.text = "(empty)"
                            } else {
                                self.phoneNumber.text = phone + " " + self.verifNumber
                            }
                            
                            if (email == "(Empty)") {
                                self.email.text = "(empty)"
                            } else {
                                if (verifEmail == true) {
                                    let statusEmail = "(Verified)"
                                    self.email.text = email + " " + statusEmail
                                } else {
                                    let statusemail = "(Unverified)"
                                    self.email.text = email + " " + statusemail
                                }
                                
                            }
                            
                            self.id_number.text = data9
                            self.address.text = data10
                            self.city.text = data11
                            self.province.text = data12
                            self.zip_code.text = data13
                            self.country.text = data14
                            
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
        
    }
    
    @objc func editButtonAction(sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "showEditPublic", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditPublic" {
            navigationItem.title = nil
        }
    }
}
