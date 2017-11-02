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
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventContent: UITextView!
    
    
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Detail Event"
        
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

extension String {
    var htmlAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var htmlString: String {
        return html2AttributedString?.string ?? ""
    }
}
