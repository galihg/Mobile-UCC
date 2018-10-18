//
//  MerchantView2.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 10/24/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class MerchantView2: UIViewController {

    @IBOutlet weak var merchantLogo: UIImageView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantAddress: UILabel!
    @IBOutlet weak var valid_date: UILabel!
    @IBOutlet weak var merchantBanner: UIImageView!
    @IBOutlet weak var merchantPromo: UITextView!
    
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        merchantName.text = (passedData[0] as! String)
        
        let merchantAddressRaw = (passedData[1] as! String)
        merchantAddress.text = merchantAddressRaw.htmlString
        
        valid_date.text = (passedData[3] as! String)
        
        let merchantPromoRaw = (passedData[9] as! String)
        merchantPromo.text = merchantPromoRaw.htmlString
        
        let passedURL1 = passedData[2]
        let networkService = NetworkService(url: passedURL1 as! URL)
            networkService.downloadImage({ (imageData) in
                let image = UIImage(data: imageData as Data)
                DispatchQueue.main.async(execute: {
                    self.merchantLogo.image = image
            })
        })
        
        let passedURL2 = passedData[8]
        let networkService2 = NetworkService(url: passedURL2 as! URL)
        networkService2.downloadImage({ (imageData) in
            let image = UIImage(data: imageData as Data)
            DispatchQueue.main.async(execute: {
                self.merchantBanner.image = image
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.title = "Merchant Detail"
         Auth.auth_check()
    }
    @IBAction func passInfo(_ sender: Any) {
        
        let date_joined = (passedData[3] as! String)
        let merchantContact = (passedData[4] as! String)
        let merchantEmail = (passedData[5] as! String)
        let merchantWeb = (passedData[6] as! String)
        
        let passedArray = [date_joined, merchantContact, merchantEmail, merchantWeb] as [Any]
        
        self.performSegue(withIdentifier: "infoMerchant", sender: passedArray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoMerchant" {
            
            let Merchant3VC = segue.destination as! MerchantView3
            let pass = sender as! [Any]
            Merchant3VC.passedData = pass
            navigationItem.title = nil
            
        }
    }

    



}
