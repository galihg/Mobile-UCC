//
//  CompanyInfo.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/23/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class CompanyInfo: BaseViewController {

    @IBOutlet weak var logoPerusahaan: UIImageView!
    @IBOutlet weak var namaPerusahaan: UILabel!
    @IBOutlet weak var alamatPerusahaan: UILabel!
    @IBOutlet weak var profilPerusahaan: UITextView!
    @IBOutlet weak var kontakPerusahaan: UILabel!
    @IBOutlet weak var webPerusahaan: UILabel!
    @IBOutlet weak var contact_icon: UIImageView!
    @IBOutlet weak var web_icon: UIImageView!
    @IBOutlet weak var loc_icon: UIImageView!
    
    
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Company Info"
        
        namaPerusahaan.text = (passedData[5] as! String)
        alamatPerusahaan.text = (passedData[0] as! String)
        kontakPerusahaan.text = (passedData[2] as! String)
        webPerusahaan.text = (passedData[3] as! String)
        
        if (kontakPerusahaan == nil) {
            self.contact_icon.isHidden = true
        }
        if (webPerusahaan == nil) {
            self.web_icon.isHidden = true
        }
        if (alamatPerusahaan == nil) {
            self.loc_icon.isHidden = true
        }
        
        let passedURL = passedData[4]
        let networkService = NetworkService(url: passedURL as! URL)
        networkService.downloadImage({ (imageData) in
            let image = UIImage(data: imageData as Data)
            DispatchQueue.main.async(execute: {
                self.logoPerusahaan.image = image
            })
        })
        
        let profilRaw = (passedData[1] as! String)
        profilPerusahaan.text = profilRaw.html2String
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
