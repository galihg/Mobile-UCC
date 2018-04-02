//
//  PublicInformation.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class EditPublicInformation: UIViewController {

    @IBOutlet weak var radioBtn: DLRadioButton!
    @IBOutlet weak var radioBtn2: DLRadioButton!
    
    var sex: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Public Information"
        // Do any additional setup after loading the view.
        sex = "male"
        
        radioBtn.isSelected = true
        
        
    }

    @IBAction func radioBtnAction(_ sender: DLRadioButton) {
        
        if (sender.tag == 1) {
            radioBtn2.isSelected = false
            print ("Male")
        } else if (sender.tag == 2){
            radioBtn.isSelected = false
            print ("Female")
        }
    }
    
}
