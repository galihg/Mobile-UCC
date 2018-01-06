//
//  ProfileSummary.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 11/21/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class ProfileSummary: UIViewController {

    @IBOutlet var profileSum: UITextView!
    @IBOutlet var addProfileSum: UIButton!
    
    var passedData : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Profile Summary"
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
        
        profileSum.text = passedData
        
        if (profileSum.text != "(empty)") {
            addProfileSum.isHidden = true
            profileSum.isHidden = false
        } else {
            profileSum.isHidden = true
            addProfileSum.isHidden = false
        }
        
    }
    
    func editButtonAction(sender: UIBarButtonItem){
        
    }

}
