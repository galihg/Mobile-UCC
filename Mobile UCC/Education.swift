//
//  Education.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/10/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class Education: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    var pendidikan = [Pendidikan]()
    
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

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
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        self.title = "Education"
        self.navigationItem.title="Education"
        downloadAllEducation()
        
    }
    
    @objc func newButtonAction(sender: UIBarButtonItem){
        let educationId = "-1"
        getForm(educationId)
    }
    
    func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        //addButton.setImage(UIImage(named: "add2"),for: UIControlState())
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControl.State())
        addButton.addTarget(self, action: #selector(addEducation), for: .touchUpInside)
        addButton.setTitle("         ADD FORMAL EDUCATION", for: [])
        self.view.addSubview(addButton)
        addButton.isHidden = false 
    }
    
    func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    func downloadAllEducation () {
        
        pendidikan = []
        HUD.show(.progress)
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/education"
       
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let educationDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for educationDictionary in educationDictionaries {
                        let eachEducation = educationDictionary 
                        let id_education = eachEducation ["id_pddk"] as? String
                        let id_member = eachEducation ["id_member"] as? String
                        let degree = eachEducation ["jenjang"] as? String
                        let univ_name = eachEducation ["universitas"] as? String
                        let major = eachEducation ["jurusan"] as? String
                        let year_in = eachEducation ["thn_masuk"] as? String
                        let year_out = eachEducation ["thn_lulus"] as? String
                        let ipk = eachEducation ["ipk"] as? String
                        
                        self.pendidikan.append(Pendidikan(id_education: id_education!, id_member: id_member!, degree: degree!, univ_name: univ_name!, major: major!, year_in: year_in!, year_out: year_out!, ipk: ipk!))
                    }
                    
                    DispatchQueue.main.async {
                       
                        self.tableView.reloadData()
                        if (self.pendidikan.count == 0){
                            self.setAddButton()
                        }
                        HUD.hide()
                        
                    }
                } else if (status == "invalid-session"){
                    
                    let keychain = KeychainSwift()
                    let preferences = UserDefaults.standard
                    
                    keychain.clear()
                    preferences.removeObject(forKey: "session")
                    
                    Alert.showMessage(title: "WARNING!", msg: session_end_message)
                    
                    DispatchQueue.main.async {
                        self.openViewControllerBasedOnIdentifier("Home")

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
        if pendidikan.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return pendidikan.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell", for: indexPath) as! educationCell
        let pendidikan = self.pendidikan[indexPath.row]
        
        cell.pendidikan = pendidikan
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(Education.edit_education(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(Education.delete_education(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addEducation(_ button: UIButton) {
        
        let educationId = "-1"
        getForm(educationId)
        
    }
    
    @IBAction func edit_education(_ sender: Any) {
        let data = pendidikan[(sender as AnyObject).tag]
        let educationId = data.id_education
    
        getForm(educationId!)
        
    }
    
    func getForm(_ educationId: String) {
        
        let formId = educationId
        self.performSegue(withIdentifier: "showEditEducation", sender: formId)
        
    }
    
    @IBAction func delete_education(_ sender: Any) {
        let data = pendidikan[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let educationId = data.id_education
        
        deleteEducation(indexPath!, educationId!)
    }
    
    func deleteEducation (_ row:IndexPath,_ id:String) {
        
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/education/"
        let paramToSend = "id_pendidikan=" + id

        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.pendidikan.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        //self.downloadAllEducation()
                    }
                }  else if (status == "error"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showEditEducation") {
            navigationItem.title = nil
            let Education2VC = segue.destination as! EditEducation
            let pass = sender as! String
            Education2VC.passedData = pass
        }
    }
   
    

}


