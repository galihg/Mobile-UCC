//
//  OrganizationExperience.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 12/27/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class OrganizationExperience: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var organisasi = [Organisasi]()
    
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
        self.title = "Organization Experience"
        downloadAllOrganization()
    }
    
    @objc func newButtonAction(sender: UIBarButtonItem){
        let orgId = "-1"
        performSegue(withIdentifier: "showEditOrganization", sender: orgId)
    }
    
    private func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControl.State())
        addButton.addTarget(self, action: #selector(addOrganization), for: .touchUpInside)
        addButton.setTitle("          ADD ORGANIZATION EXPERIENCE", for: [])
        addButton.titleLabel!.font = UIFont(name: "Helvetica Neue", size: 12)
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    
    func downloadAllOrganization () {
        HUD.show(.progress)
        organisasi = []
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/organization"
        
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let orgDictionaries = server_response["data"] as! NSArray
                    
                    for orgDictionary in orgDictionaries {
                        let eachOrg = orgDictionary as! [String:Any]
                        let id_org = eachOrg ["id_org"] as? String
                        let id_member = eachOrg ["id_member"] as? String
                        let namaOrg = eachOrg ["nama_org"] as? String
                        let posisi = eachOrg ["posisi"] as? String
                        let deskripsi = eachOrg ["deskripsi"] as? String
                        let tglMasuk = eachOrg ["tgl_masuk"] as? String
                        let tglKeluar = eachOrg ["tgl_keluar"] as? String
                        let aktif = eachOrg ["aktif"] as? String
                        
                        self.organisasi.append(Organisasi(id_organisasi: id_org!, id_member: id_member!, nama_organisasi: namaOrg!, posisi: posisi!, deskripsi: deskripsi!, year_in: tglMasuk!, year_out: tglKeluar!, active: aktif!))
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if (self.organisasi.count == 0){
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
        if organisasi.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return organisasi.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "organizationCell", for: indexPath) as! organizationCell
        let organisasi = self.organisasi[indexPath.row]
        
        cell.organisasi = organisasi
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(OrganizationExperience.edit_org(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(OrganizationExperience.delete_org(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addOrganization(_ button: UIButton) {
        let orgId = "-1"
        performSegue(withIdentifier: "showEditOrganization", sender: orgId)
    }
    
    @IBAction func edit_org(_ sender: Any) {
        let data = organisasi[(sender as AnyObject).tag]
        let orgId = data.id_organisasi
        performSegue(withIdentifier: "showEditOrganization", sender: orgId)
    }
    
    @IBAction func delete_org(_ sender: Any) {
        let data = organisasi[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let orgId = data.id_organisasi
        
        deleteOrg(indexPath!, orgId!)
    }
  
    func deleteOrg(_ row:IndexPath,_ id:String) {
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/organization/"
        let paramToSend = "id_data=" + id

        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.organisasi.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        self.downloadAllOrganization()
                    }
                } else if (status == "error"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditOrganization" {
            let Org2VC = segue.destination as! EditOrganizationExperience
            let pass = sender as! String
            Org2VC.passedData = pass
            navigationItem.title = nil
        }
    }
    
}
