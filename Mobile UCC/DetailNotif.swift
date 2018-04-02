//
//  DetailNotif.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 9/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import WebKit

class DetailNotif: BaseViewController, WKUIDelegate{

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: WKWebView!
    
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
        content.loadHTMLString(rawContent, baseURL: Bundle.main.bundleURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ViewControllers view ist fully loaded and could present further ViewController
        //Here you could do any other UI operations
        if Reachability.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            controller.addAction(ok)
            controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
        }
        
    }


    
    


}
