//
//  merchantCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class merchantCell: UITableViewCell {

    
    @IBOutlet weak var merchantBanner: UIImageView!
    @IBOutlet weak var valid_date: UILabel!
    @IBOutlet weak var detailMerchant: UIButton!
   

    var merchant: Merchant! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        
        valid_date.text = merchant.valid
        
        
        if let logo = merchant.banner {
            let networkService = NetworkService(url: logo)
            networkService.downloadImage { (imageData) in
                let image = UIImage(data: imageData as Data)
                self.merchantBanner.image = image
            }
        }
    }
}


