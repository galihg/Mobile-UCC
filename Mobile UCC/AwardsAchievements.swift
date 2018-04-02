//
//  AwardsAchievements.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 07/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class AwardsAchievements: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var award = [Award]()
    
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        //create a new button
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
        self.title = "Awards and Achievements"
        downloadAllAward()
    }
    
    func newButtonAction(sender: UIBarButtonItem){
        
    }
    
    private func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        //addButton.setImage(UIImage(named: "add2"),for: UIControlState())
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControlState())
        addButton.addTarget(self, action: #selector(addAward), for: .touchUpInside)
        addButton.setTitle("          ADD AWARDS AND ACHIEVEMENTS", for: [])
        addButton.titleLabel!.font = UIFont(name: "Helvetica Neue", size: 13)
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    func downloadAllAward () {
        
        HUD.show(.progress)
        award = []
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/achievement"

        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let awardDictionaries = server_response["data"] as! NSArray
                    
                    for awardDictionary in awardDictionaries {
                        let eachAward = awardDictionary as! [String:Any]
                        let id_prestasi = eachAward ["id_prestasi"] as? String
                        let id_member = eachAward ["id_member"] as? String
                        let nama_prestasi = eachAward ["nama_prestasi"] as? String
                        let pemberi = eachAward ["pemberi"] as? String
                        let tahun = eachAward ["tahun"] as? String
                        let keterangan = eachAward ["keterangan"] as? String
                        
                        self.award.append(Award(id_prestasi: id_prestasi!, id_member: id_member!, nama_prestasi: nama_prestasi!, pemberi: pemberi!, tahun: tahun!, keterangan: keterangan!))
                    }
                
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if (self.award.count == 0){
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
        if award.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return award.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "awardCell", for: indexPath) as! awardCell
        let award = self.award[indexPath.row]
        
        cell.award = award
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(AwardsAchievements.edit_award(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(AwardsAchievements.delete_award(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addAward(_ button: UIButton) {
        print("Button pressed 👍")
    }
    

    @IBAction func edit_award(_ sender: Any) {
    }
    
    @IBAction func delete_award(_ sender: Any) {
        let data = award[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let awardId = data.id_prestasi
        
        deleteAward(indexPath!, awardId!)
    }
    
    
    func deleteAward (_ row:IndexPath,_ id:String) {
    
        let url = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/achievement"
        let paramToSend = "id_data=" + id
 
        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.award.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        self.downloadAllAward()
                    }
                } else if (status == "error"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
        
    }
    
}
