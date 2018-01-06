//
//  EnglishSkill.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/24/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class EnglishSkill: UIViewController {
    
    @IBOutlet var ContentView: [UILabel]!
    @IBOutlet var ImageView: [UIImageView]!
    
    @IBOutlet var toeflType: UILabel!
    @IBOutlet var toeflScore: UILabel!
    @IBOutlet var toeflYear: UILabel!
    @IBOutlet var ieltsScore: UILabel!
    @IBOutlet var ieltsYear: UILabel!
    @IBOutlet var toeicScore: UILabel!
    @IBOutlet var toeicYear: UILabel!
    
    var passedData : [String] = []
    let editButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "English Skill"
        
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
        
        
        let rawType = passedData[2]
        if rawType == "1" {
            toeflType.text = "PBT"
        } else if rawType == "2" {
            toeflType.text = "CBT"
        } else if rawType == "3" {
            toeflType.text = "iBT"
        } else {
            toeflType.text = "(empty)"
        }
        
        toeflScore.text = passedData[3]
        toeflYear.text = passedData[4]
        ieltsScore.text = passedData[5]
        ieltsYear.text = passedData[6]
        toeicScore.text = passedData[7]
        toeicYear.text = passedData[8]
        
        
        
        /*for contents in ContentView {
            if (contents.text == "(empty)") {
                contents.isHidden = true
                for images in ImageView {
                    images.isHidden = true
                }
                setEditButton()
            } else {
                contents.isHidden = false
                for images in ImageView {
                    images.isHidden = false
                }
                removeEditButton()
                
            }
        }*/
        
    }
    
    func editButtonAction(sender: UIBarButtonItem){
        
    }
    
    private func setEditButton() {
        
        editButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        editButton.setBackgroundImage(UIImage(named: "edit2"), for: UIControlState())
        editButton.addTarget(self, action: #selector(editEnglish), for: .touchUpInside)
        editButton.setTitle("         EDIT ENGLISH SKILL", for: [])
        self.view.addSubview(editButton)
    }
    
    private func removeEditButton() {
        
        editButton.isHidden = true
        
    }
    
    func editEnglish(_ button: UIButton) {
        print("Button pressed 👍")
    }


}
