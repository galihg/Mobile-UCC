//
//  ProfileSummary.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class EditProfileSummary: UIViewController {

    @IBOutlet weak var profileEdit: UITextView!
    
    var passedData : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile Summary"
        
        // Do any additional setup after loading the view.
        
        profileEdit.text = passedData
        self.profileEdit.delegate = self as? UITextViewDelegate
        self.profileEdit.layer.borderWidth = 1.0
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.blue.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        profileEdit.resignFirstResponder()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        profileEdit.resignFirstResponder()
        let profilString = profileEdit.text
        DoSave(profilString!)
    }
    
    func DoSave(_ profil:String) {
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/shortprofile"
        let paramToSend = "profil=" + profil

        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let message = server_response["message"] as? String {
                Alert.showMessage(title: "WARNING!", msg: message)
            }
        }
        
    }
    

}
