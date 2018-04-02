//
//  LanguageSkills.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/21/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class LanguageSkills: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var langLabel: UILabel!
    @IBOutlet var skllLabel: UILabel!
    @IBOutlet weak var blueLine: UIImageView!
    
    var language = [Language]()
    
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
        self.title = "Language Skills"
        downloadAllLanguage()
    }
    
    func newButtonAction(sender: UIBarButtonItem){
        
    }
    
    private func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControlState())
        addButton.addTarget(self, action: #selector(addLanguage), for: .touchUpInside)
        addButton.setTitle("         ADD LANGUAGE SKILLS", for: [])
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
    }
    
    func downloadAllLanguage () {
        HUD.show(.progress)
        language = []
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/foreignlanguage"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    
                    let languageDictionaries = server_response["data"] as! NSArray
                    
                    for languageDictionary in languageDictionaries {
                        let eachLanguage = languageDictionary as! [String:Any]
                        let id_bahasa = eachLanguage ["id_bhs"] as? String
                        let id_member = eachLanguage ["id_member"] as? String
                        let bahasa = eachLanguage ["bahasa"] as? String
                        let skill = eachLanguage ["kemampuan"] as? String
                        
                        
                        self.language.append(Language(id_bahasa: id_bahasa!, id_member: id_member!, bahasa: bahasa!, kemampuan: skill!))
                    }
                    print(self.language)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if (self.language.count == 0){
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
        if language.count == 0 {
            tableView.isHidden = true
            setAddButton()
            langLabel.isHidden = true
            skllLabel.isHidden = true
            blueLine.isHidden = true
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            langLabel.isHidden = false
            skllLabel.isHidden = false
            return language.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! languageCell
        let language = self.language[indexPath.row]
        
        cell.bahasa = language
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(LanguageSkills.edit_language(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(LanguageSkills.delete_language(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addLanguage(_ button: UIButton) {
        print("Button pressed 👍")
    }
    
    @IBAction func edit_language(_ sender: Any) {
        
    }

    @IBAction func delete_language(_ sender: Any) {
        let data = language[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let languageId = data.id_bahasa
        
        deleteLanguage(indexPath!, languageId!)
    }
    
    func deleteLanguage (_ row:IndexPath,_ id:String) {
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/foreignlanguage/"
        
        NetworkService.parseJSONFromURL(url, "POST", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok") {
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.language.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        self.downloadAllLanguage()
                    }
                } else if (status == "error") {
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
        
    }
    
}
