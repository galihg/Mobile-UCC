//
//  CTC.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 15/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class CTC: BaseViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var course = [Course]()

    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "add"),for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(newButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Course / Training / Certification"
        downloadAllCTC()
    }
    
    func newButtonAction(sender: UIBarButtonItem){
        let ctcId = ["-1"]
        performSegue(withIdentifier: "showEditCTC", sender: ctcId)
    }
  
    private func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        //addButton.setImage(UIImage(named: "add2"),for: UIControlState())
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControlState())
        addButton.addTarget(self, action: #selector(addCTC), for: .touchUpInside)
        addButton.setTitle("            ADD COURSE / TRAINING / CERTIFICATION", for: [])
        addButton.titleLabel!.font = UIFont(name: "Helvetica Neue", size: 11)
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        addButton.isHidden = true
    }
    
    func downloadAllCTC () {
        HUD.show(.progress)
        course = []
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/courses"

        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let ctcDictionaries = server_response["data"] as! NSArray
                    
                    for ctcDictionary in ctcDictionaries {
                        let eachCTC = ctcDictionary as! [String:Any]
                        let id_ctc = eachCTC ["id_kursus"] as? String
                        let id_member = eachCTC ["id_member"] as? String
                        let nama_kursus = eachCTC ["nama_kursus"] as? String
                        let tahun = eachCTC ["thn"] as? String
                        let organizer = eachCTC ["penyelenggara"] as? String
                        let sertifikat = eachCTC ["sertifikat"] as? String
                        
                        self.course.append(Course(id_ctc: id_ctc!, id_member: id_member!, nama_kursus: nama_kursus!, tahun: tahun!, organizer: organizer!, sertifikat: sertifikat!))
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if (self.course.count == 0){
                            self.setAddButton()
                        }
                        HUD.hide()
                    }
                } else if (status == "invalid-session"){
                    
                    let preferences = UserDefaults.standard
                    preferences.removeObject(forKey: "session")
                    
                    DispatchQueue.main.async {
                        self.openViewControllerBasedOnIdentifier("Home")
                        Alert.showMessage(title: "WARNING!", msg: "Sesi Login telah berakhir, silahkan login ulang")
                    }
                }
            }
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if course.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return course.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CTCCell", for: indexPath) as! CTCCell
        let course = self.course[indexPath.row]
        
        cell.course = course
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(CTC.editCTC(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(CTC.deleteCTC(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addCTC(_ button: UIButton) {
        let ctcId = ["-1"]
        performSegue(withIdentifier: "showEditCTC", sender: ctcId)
    }
    
    @IBAction func editCTC(_ sender: Any) {
        let data = course[(sender as AnyObject).tag]
        let ctcId = data.id_ctc
        let ctcName = data.nama_kursus
        let ctcOrganizer = data.organizer
        let ctcCertificate = data.sertifikat
        let ctcYear = data.tahun
        
        let passedArray = [ctcId, ctcName, ctcOrganizer, ctcCertificate, ctcYear]
        performSegue(withIdentifier: "showEditCTC", sender: passedArray)
    }
    
    @IBAction func deleteCTC(_ sender: Any) {
        let data = course[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let ctcId = data.id_ctc

        deleteCourses(indexPath!, ctcId!)
        
    }
    
    func deleteCourses (_ row:IndexPath,_ id:String) {
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/courses"
        let paramToSend = "id_data=" + id

        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.course.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        self.downloadAllCTC()
                    }
                } else if (status == "error"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditCTC" {
            let CTC2VC = segue.destination as! EditCTC
            let pass = sender as! [String]
            CTC2VC.passedData = pass
            navigationItem.title = nil
        }
    }

}
