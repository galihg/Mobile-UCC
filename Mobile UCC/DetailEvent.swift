//
//  DetailEvent.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/23/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class DetailEvent: BaseViewController {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventBanner: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventLocation: UITextView!
    @IBOutlet weak var eventContent: UITextView!
    
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        eventName.text = (passedData[0] as? String)
        eventLocation.text = (passedData[3] as? String)
        
        let date = passedData[4]
        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString : NSDate = dateFormatter.date(from: date as! String)! as NSDate
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let datenew = dateFormatter.string(from: dateFromString as Date)
        eventDate.text = datenew
        
        let eventContentRaw = (passedData[2] as! String)
        eventContent.text = eventContentRaw.htmlString
        
        let passedURLString = (passedData[1] as? String)
        
        if (passedURLString != "nil") {
            let url_Banner = URL (string: passedURLString!)
            let networkService = NetworkService(url: url_Banner!)
            networkService.downloadImage({ (imageData) in
                let image = UIImage(data: imageData as Data)
                DispatchQueue.main.async(execute: {
                    self.eventBanner.image = image
                })
            })
        } else {
            self.eventBanner.image = UIImage(named: "Logo UCC putih")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
        self.title = "Event Detail"
        
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
            Alert.showMessage(title: "No Internet Detected", msg: "This app requires an Internet connection")
            
            //HUD.hide()
        }
        
    }
    
}

