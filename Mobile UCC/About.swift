//
//  About.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/17/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class About: BaseViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        self.title = "About"
        
        if (defaults.object(forKey: "session") != nil ) {
            Auth.auth_check()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
