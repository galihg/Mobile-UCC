//
//  ResetPassword.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 13/10/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class ResetPassword: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var _email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _email.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        self.navigationController?.isNavigationBarHidden = false

    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        HUD.show(.progress)
        _email.resignFirstResponder()
        
        let url = "http://api.career.undip.ac.id/v1/auth/forgotpassword"
        let paramToSend = "auth_uname=" + _email.text!
        
        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String {
                if let message = server_response["message"] as? String {
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                    if (status == "ok"){
                        Alert.showMessage(title: "SUCCESS!", msg: message)
                    } else {
                        Alert.showMessage(title: "WARNING!", msg: message)
                    }
                }
            }
        }
    }
    

    

}
