//
//  WorkExperience.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/20/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class WorkExperience: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var work = [Work]()
    
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view."
        
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "add"),for: UIControl.State())
        //add function for button
        button.addTarget(self, action: #selector(newButtonAction(sender:)), for: UIControl.Event.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Work Experience"
        downloadAllExperience()
    }
    
    @objc func newButtonAction(sender: UIBarButtonItem){
        let workId = "-1"
        getForm(workId)
    }
    
    private func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        //addButton.setImage(UIImage(named: "add2"),for: UIControlState())
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControl.State())
        addButton.addTarget(self, action: #selector(addWork), for: .touchUpInside)
        addButton.setTitle("         ADD WORK EXPERIENCE", for: [])
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    
    func downloadAllExperience () {
        HUD.show(.progress)
        work = []
    
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/work"

        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let workDictionaries = server_response["data"] as! NSArray
                    
                    for workDictionary in workDictionaries {
                        let eachWork = workDictionary as! [String:Any]
                        let id_pekerjaan = eachWork ["id_pekerjaan"] as? String
                        let id_member = eachWork ["id_member"] as? String
                        let perusahaan = eachWork ["perusahaan"] as? String
                        let posisi = eachWork ["posisi"] as? String
                        let deskripsi = eachWork ["deskripsi"] as? String
                        
                        
                        self.work.append(Work(id_pekerjaan: id_pekerjaan!, id_member: id_member!, perusahaan: perusahaan!, posisi: posisi!, deskripsi: deskripsi!))
                    }
                    print(self.work)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if (self.work.count == 0){
                            self.setAddButton()
                        }
                        HUD.hide()
                    } 
                } else if (status == "invalid-session") {
                    
                    let preferences = UserDefaults.standard
                    preferences.removeObject(forKey: "session")
                    
                    DispatchQueue.main.async {
                        self.openViewControllerBasedOnIdentifier("Home")
                        Alert.showMessage(title: "WARNING!", msg: "Sesi Login telah berakhir, silahkan login ulang")
                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                        NotificationCenter.default.post(name: .reload, object: nil)
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
        if work.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return work.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workCell", for: indexPath) as! workCell
        let work = self.work[indexPath.row]
        
        cell.work = work
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(WorkExperience.edit_work(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(WorkExperience.delete_work(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addWork(_ button: UIButton) {
        let workId = "-1"
        getForm(workId)
    }
    
    @IBAction func edit_work(_ sender: Any) {
        let data = work[(sender as AnyObject).tag]
        let workId = data.id_pekerjaan
        
        getForm(workId!)
    }

    @IBAction func delete_work(_ sender: Any) {
        let data = work[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let workId = data.id_pekerjaan
        
        deleteWork(indexPath!, workId!)
    }
    
    func getForm(_ workId: String) {
        let formId = workId
        self.performSegue(withIdentifier: "showEditWork", sender: formId)
    }
  
    func deleteWork (_ row:IndexPath,_ id:String) {

        let url = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/work/"
        let paramToSend = "id_pekerjaan=" + id
    
        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.work.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        self.downloadAllExperience()
                    }
                } else if (status == "error"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showEditWork") {
            navigationItem.title = nil
            let Work2VC = segue.destination as! EditWorkExperience
            let pass = sender as! String
            Work2VC.passedData = pass
        }
    }
    
}

