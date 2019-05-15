//
//  newsCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/4/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class newsCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    

    var news: News! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        newsTitle.text = news.title
        newsContent.text = news.ringkasan
        newsDate.text = news.tgl_post
        
        if let thumb_image = news.thumb_image {
            let networkService = NetworkService(url: thumb_image)
            networkService.downloadImage { (imageData) in
                let image = UIImage(data: imageData as Data)
                self.newsImage.image = image
            }
        }
    }
    
    // takes time to download stuff from the Internet
    //  | MAIN (UI)  | download  | upload  |share
    
}
