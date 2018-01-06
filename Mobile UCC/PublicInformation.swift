//
//  PublicInformation.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 11/8/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class PublicInformation: UIViewController {

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
    
    var passedData : [Any] = []
    var verifNumber : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Public Information"
        
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "edit"),for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(editButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        //isi Public Information
        fullName.text = (passedData[0] as! String)
        jobseekerTitle.text = (passedData[1] as! String)
        tglLahir.text = (passedData[2] as! String)
        tmpatLahir.text = (passedData[3] as! String)
        jenisKelamin.text = (passedData[4] as! String)
        agama.text = (passedData[5] as! String)
        maritalStatus.text = (passedData[6] as! String)
        
        let tinggiBadanRaw = (passedData[7] as! Int)
        if (tinggiBadanRaw == 0) {
            tinggiBadan.text = "(empty)"
        } else {
            tinggiBadan.text = "\(tinggiBadanRaw)"
        }
        
        
        let verifNumberRaw = (passedData[17] as! Bool)
        if (verifNumberRaw == true ) {
            verifNumber = "(Verified)"
        } else {
            verifNumber = "(Unverified)"
        }
        
        if (phoneNumber.text == "(Empty)") {
            phoneNumber.text = "(empty)"
        } else {
            phoneNumber.text = (passedData[16] as! String) + " " + verifNumber
        }
        
        if (email.text == "(Empty)") {
            email.text = "(empty)"
        } else {
            email.text = (passedData[14] as! String) + " " + (passedData[15] as! String)
        }
        
        id_number.text = (passedData[8] as! String)
        address.text = (passedData[9] as! String)
        city.text = (passedData[10] as! String)
        province.text = (passedData[11] as! String)
        zip_code.text = (passedData[12] as! String)
        country.text = (passedData[13] as! String)
        
        
    }
    
    func editButtonAction(sender: UIBarButtonItem){
        
    }
}
