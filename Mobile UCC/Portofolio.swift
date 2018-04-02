//
//  Portofolio.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 16/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class Portofolio: BaseViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var portofolios = [Portofolios]()
    
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
        self.title = "Portofolio"
        downloadAllPortofolio()
        
    }
    
    func newButtonAction(sender: UIBarButtonItem){
        
    }
    
    private func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        //addButton.setImage(UIImage(named: "add2"),for: UIControlState())
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControlState())
        addButton.addTarget(self, action: #selector(addPortofolio), for: .touchUpInside)
        addButton.setTitle("           ADD PORTOFOLIO", for: [])
        addButton.titleLabel!.font = UIFont(name: "Helvetica Neue", size: 17)
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    
    func downloadAllPortofolio () {
        HUD.show(.progress)
        portofolios = []
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/portofolio"
  
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let portDictionaries = server_response["data"] as! NSArray
                    
                    for portDictionary in portDictionaries {
                        let eachPort = portDictionary as! [String:Any]
                        let id_portofolio = eachPort ["id_portofolio"] as? String
                        let id_member = eachPort ["id_member"] as? String
                        let title = eachPort ["judul"]
                            as? String
                        let tgl_mulai = eachPort["tgl_mulai"] as? String
                        let tgl_selesai = eachPort ["tgl_selesai"] as? String
                        let alamat_URL = eachPort ["url"] as? String
                        let deskripsi = eachPort ["deskripsi"] as? String
                        
                        self.portofolios.append(Portofolios(id_portofolio: id_portofolio!, id_member: id_member!, title: title!, tgl_mulai: tgl_mulai!, tgl_selesai: tgl_selesai!, alamat_URL: alamat_URL!, deskripsi: deskripsi!))
                    }
                    print(self.portofolios)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if (self.portofolios.count == 0){
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
        if portofolios.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return portofolios.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portofolioCell", for: indexPath) as! portofolioCell
        let portofolios = self.portofolios[indexPath.row]
        
        cell.portofolios = portofolios
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(Portofolio.edit_portofolio(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(Portofolio.delete_portofolio(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addPortofolio(_ button: UIButton) {
        print("Button pressed 👍")
    }
   
    @IBAction func edit_portofolio(_ sender: Any) {
        
    }
    
    @IBAction func delete_portofolio(_ sender: Any) {
        let data = portofolios[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let portId = data.id_portofolio

        deletePortofolio(indexPath!, portId!)
        
    }
    
    func deletePortofolio (_ row:IndexPath,_ id:String) {
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/portofolio"
        let paramToSend = "id_data=" + id
   
        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String{
                if (status == "ok"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.portofolios.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        self.downloadAllPortofolio()
                    }
                } else if (status == "error"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
        
    }
    
}

