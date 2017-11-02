//
//  eventCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class eventCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var namaEvent: UILabel!
    @IBOutlet weak var lokasiEvent: UILabel!
    @IBOutlet weak var bulanEvent: UILabel!
    @IBOutlet weak var tglEvent: UILabel!
    
    
    
    var events: Events! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        namaEvent.text = events.name
        lokasiEvent.text = events.location
        
        let date = events.tgl_event
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString : NSDate  = dateFormatter.date(from: date!)! as NSDate
        
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = tempLocale
        let datenew = dateFormatter.string(from: dateFromString as Date)
        bulanEvent.text = "Mon " + datenew
        
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = tempLocale
        let datenew2 = dateFormatter.string(from: dateFromString as Date)
        tglEvent.text = datenew2
        
        let urlString_smallBanner = events.small_banner

        if (urlString_smallBanner != "nil") {
            let url_smallBanner = URL (string: urlString_smallBanner!)
            let networkService = NetworkService(url: url_smallBanner!)
            networkService.downloadImage({ (imageData) in
                let image = UIImage(data: imageData as Data)
                DispatchQueue.main.async(execute: {
                    self.eventImage.image = image
                })
            })
        } else {
            self.eventImage.image = UIImage(named: "Logo UCC putih")
        }
    }

}
