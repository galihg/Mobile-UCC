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

        //self.addSlideMenuButton()
        self.title = "UCC News"
        //let passedURL = passedData[1]

        /*let networkService = NetworkService(url: passedURL as! URL)
            networkService.downloadImage({ (imageData) in
                let image = UIImage(data: imageData as Data)
                DispatchQueue.main.async(execute: {
                    self.newsImage.image = image
                })
            })*/
        
        newsTitle.text = (passedData[0] as! String)
        let newsContentRaw = (passedData[2] as! String)
        newsContent.loadHTMLString(newsContentRaw, baseURL: Bundle.main.bundleURL)
        
        //newsContent.text = newsContentRaw.html2String
        
        //let htmlStringCode = "<i>Italics </i><b>Bold </b><u>Underline</u><blockquote>block quote<br></blockquote>"
        
        /*if let htmlText = htmlStringCode.html2AttributedString {
            let attributes = [NSFontAttributeName: UIFont(name: "Open Sans", size: 18.0)!]
            let attributedText = NSMutableAttributedString(string: htmlText.string, attributes: attributes)
            
            let htmlString = htmlText.string as NSString
            let range  = htmlString.range(of: "Italics")
            attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans-Italic", size: 18.0)!, range: range)
            
            newsContent.attributedText = attributedText
        }*/
        
        newsDate.text = (passedData[3] as! String)
        
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
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
