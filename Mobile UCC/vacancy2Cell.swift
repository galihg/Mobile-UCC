//
//  vacancy2Cell.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/27/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class vacancy2Cell: UITableViewCell {
    
    @IBOutlet weak var namaLowongan: UILabel!
    @IBOutlet weak var totalApplicants: UILabel!
    @IBOutlet weak var due_date: UILabel!
    @IBOutlet weak var posisiPekerjaan: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var pendidikanMinimal: UILabel!
    @IBOutlet weak var tipeLowongan: UILabel!
    @IBOutlet weak var tempatKerja: UILabel!
    @IBOutlet weak var detailPass: UIButton!
   
    
    
    

    var detailVacancy: DetailVacancy! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        namaLowongan.text = detailVacancy.vacancy_name
        totalApplicants.text = "\(detailVacancy.total_applicants ?? 1)"
        due_date.text = "\(detailVacancy.remaining_days ?? 1)"
        posisiPekerjaan.text = detailVacancy.job_position
        pendidikanMinimal.text = detailVacancy.min_education
        tipeLowongan.text = detailVacancy.type_vacancy
        
        
        let batas_waktu = detailVacancy.deadline
        
        if (batas_waktu != "nil") {
            deadline.text = batas_waktu
        }
        else {
            deadline.text = "(tidak ada deadline)"
        }
        
        let tempat_penugasan = detailVacancy.assignment
        
        if (batas_waktu != "nil") {
            tempatKerja.text = tempat_penugasan
        }
        else {
            tempatKerja.text = "(tidak ada keterangan)"
        }
        

    }
    
    // takes time to download stuff from the Internet
    //  | MAIN (UI)  | download  | upload  |share
    
}


