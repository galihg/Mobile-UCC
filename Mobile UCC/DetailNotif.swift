//
//  DetailNotif.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 9/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class DetailNotif: BaseViewController {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UITextView!
    
    
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Detail Notification"
        content.sizeToFit()
        
        type.text = (passedData[0] as! String)
        subject.text = (passedData[1] as! String)
        date.text = (passedData[2] as! String)
        
        let rawContent = (passedData[3] as! String)
        content.text = rawContent.html2String
    
    }

    
    


}
