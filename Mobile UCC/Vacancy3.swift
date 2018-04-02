//
//  Vacancy3.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/26/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class Vacancy3: BaseViewController {

    @IBOutlet weak var jobPosition: UILabel!
    @IBOutlet weak var batasWaktu: UILabel!
    @IBOutlet weak var minimalEducation: UILabel!
    @IBOutlet weak var tipePekerjaan: UILabel!
    @IBOutlet weak var tempatKerja: UILabel!
    @IBOutlet weak var jumlahPendaftar: UILabel!
    @IBOutlet weak var applyOnline: UILabel!
    @IBOutlet weak var btn_apply: UIButton!
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var namaPerusahaan: UILabel!
    @IBOutlet weak var jumlahPendaftar2: UILabel!
    @IBOutlet weak var jobClosed: UILabel!
    @IBOutlet weak var tglPublish: UILabel!
    @IBOutlet weak var kategoriPosisi: UILabel!
    @IBOutlet weak var waktuValid: UILabel!
    @IBOutlet weak var syaratUmum: UITextView!
    @IBOutlet weak var syaratKhusus: UITextView!
    @IBOutlet weak var informasi: UITextView!
    
    
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        jobName.text = (passedData[0] as! String)
        jobPosition.text = (passedData[3] as! String)
        kategoriPosisi.text = (passedData[3] as! String)
        namaPerusahaan.text = (passedData[1] as! String)
        
        let rawbatasWaktu = (passedData[4] as! String)
        if (rawbatasWaktu != "nil") {
            batasWaktu.text = rawbatasWaktu
        }
        else {
            batasWaktu.text = "(tidak ada deadline)"
        }
        
        minimalEducation.text = (passedData[5] as! String)
        tipePekerjaan.text = (passedData[6] as! String)
        
        let rawtempatKerja = (passedData[7] as! String)
        if (rawtempatKerja != "nil") {
            tempatKerja.text = rawtempatKerja
        }
        else {
            tempatKerja.text = "(tidak ada keterangan)"
        }
        
        jumlahPendaftar2.text = "\(passedData[2] ?? 0)"
        
        let rawapplyOnline = "\(passedData[8])"
        if (rawapplyOnline == "true") {
            applyOnline.text = "Yes"
        }
        else {
            applyOnline.text = "No"
        }
        
        if (applyOnline.text == "No"){
            btn_apply.isHidden = true
        } else {
            btn_apply.isHidden = false
        }
        
        let rawClosed = "\(passedData[9])"
        if (rawClosed == "true") {
            jobClosed.text = "Yes"
        }
        else {
            jobClosed.text = "No"
        }
        
        tglPublish.text = (passedData[10] as! String)
        waktuValid.text = "\(passedData[11] ?? 0)"
        
        let globalReqRaw = (passedData[12] as! String)
        syaratUmum.text = globalReqRaw.htmlString
        
        let specialReqRaw = (passedData[13] as! String)
        syaratKhusus.text = specialReqRaw.htmlString
    
        let infoRaw = (passedData[14] as! String)
        informasi.text = infoRaw.htmlString

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        self.title = "Detail Vacancy"
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "session") != nil ) {
            Auth.auth_check()
        }
    }
    
    @IBAction func apply_online(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if(defaults.object(forKey: "session") != nil)
        {
            let id = (passedData[15] as! String)
            performSegue(withIdentifier: "applyNow", sender: id)
        } else {
            performSegue(withIdentifier: "login", sender: self)
            Alert.showMessage(title: "WARNING!", msg: "Anda harus login terlebih dahulu")
            
            print("reference not found")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "applyNow" {
            
            let ApplyVC = segue.destination as! ApplyVacancy
            let pass = sender as! String
            ApplyVC.passedData = pass
            navigationItem.title = nil
        }
    }
}
