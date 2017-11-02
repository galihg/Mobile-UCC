//
//  MerchantView3.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 10/27/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class MerchantView3: UIViewController {
    @IBOutlet weak var dateJoined: UILabel!
    @IBOutlet weak var merchantContact: UILabel!
    @IBOutlet weak var merchantEmail: UILabel!
    @IBOutlet weak var merchantWeb: UILabel!
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var contactIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var webIcon: UIImageView!
    @IBOutlet weak var joinedText: UILabel!

    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Merchant Info"
        
        dateJoined.text = (passedData[0] as! String)
        if (dateJoined.text == "nil") {
            dateJoined.isHidden = true
            dateIcon.isHidden = true
            joinedText.isHidden = true
        }
        
        merchantContact.text = (passedData[1] as! String)
        if (merchantContact.text == "nil") {
            merchantContact.isHidden = true
            contactIcon.isHidden = true
        }
        
        
        merchantEmail.text = (passedData[2] as! String)
        if (merchantEmail.text == "nil") {
            merchantEmail.isHidden = true
            emailIcon.isHidden = true
        }
        
        
        merchantWeb.text = (passedData[3] as! String)
        if (merchantWeb.text == "nil") {
            merchantWeb.isHidden = true
            webIcon.isHidden = true
        }
        
        
        
    }



}
