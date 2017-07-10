//
//  DetailEvent.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/23/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class DetailEvent: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        self.title = "Detail Event"
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
