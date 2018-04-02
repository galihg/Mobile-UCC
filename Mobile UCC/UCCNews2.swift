//
//  UCCNews2.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/23/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import WebKit

class UCCNews2: BaseViewController, WKUIDelegate {
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsContent: WKWebView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "UCC News"
        
        newsTitle.text = (passedData[0] as! String)
        let newsContentRaw = (passedData[2] as! String)
        newsContent.loadHTMLString(newsContentRaw, baseURL: Bundle.main.bundleURL)
        
        newsDate.text = (passedData[3] as! String)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "session") != nil ) {
           Auth.auth_check()
        }
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

