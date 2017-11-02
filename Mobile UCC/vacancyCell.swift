//
//  vacancyCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/28/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class vacancyCell: UITableViewCell {
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var bidangIndustri: UILabel!
    @IBOutlet weak var jumlahLowongan: UILabel!
    
    

    var vacancy: Vacancy! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        companyName.text = vacancy.company_name
        jumlahLowongan.text = "\(vacancy.total_vacancy ?? 1)"
        bidangIndustri.text = vacancy.industry_type
        
        
        if let company_logo = vacancy.company_logo {
            let networkService = NetworkService(url: company_logo)
            networkService.downloadImage({ (imageData) in
                let image = UIImage(data: imageData as Data)
                DispatchQueue.main.async(execute: {
                    self.companyLogo.image = image
                })
            })
        }
    }
    
    // takes time to download stuff from the Internet
    //  | MAIN (UI)  | download  | upload  |share
    
}

    



