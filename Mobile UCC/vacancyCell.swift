//
//  vacancyCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/28/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class vacancyCell: UITableViewCell {
    

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var gambarGambar: UIImageView!
    
    
    var author: String? {
        didSet {
            authorLabel.text = author
        }
    }
    
    var quote: String? {
        didSet {
            quoteLabel.text = quote
        }
    }
    
    var gambar: UIImage? {
        didSet {
            gambarGambar.image = gambar
        }
    }

}
