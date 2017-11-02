//
//  historyCell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 9/26/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class historyCell: UITableViewCell {

    @IBOutlet weak var logoPerusahaan: UIImageView!
    @IBOutlet weak var namaLowongan: UILabel!
    @IBOutlet weak var namaPerusahaan: UILabel!
    @IBOutlet weak var tglApply: UILabel!
    @IBOutlet weak var statusLamaran: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    
        
    var history: History! {
        didSet {
            self.updateUI()
        }
    }
        
    func updateUI()
    {
    namaLowongan.text = history.vacancy_name
    namaPerusahaan.text = history.company_name
    tglApply.text = history.tgl_apply
        
    let apply_status = history.status_apply
        if (apply_status == 99) {
            statusLamaran.text = "Pending"
        } else if (apply_status == 1) {
            statusLamaran.text = "Processed"
        } else {
            statusLamaran.text = "Rejected"
        }
    let cancel_status = history.status_cancel
        if (cancel_status == true) {
            btn_cancel.isHidden = false
        } else {
            btn_cancel.isHidden = true
        }
        
    if let company_logo = history.company_logo {
        let networkService = NetworkService(url: company_logo)
            networkService.downloadImage({ (imageData) in
                let image = UIImage(data: imageData as Data)
                    DispatchQueue.main.async(execute: {
                        self.logoPerusahaan.image = image
                    })
            })
        }
    }
        
        // takes time to download stuff from the Internet
        //  | MAIN (UI)  | download  | upload  |share
        
}

