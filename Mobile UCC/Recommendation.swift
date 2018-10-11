//
//  Recommendation.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 08/01/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class Recommendation: BaseViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var rekomendasi = [Rekomendasi]()
    
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
        self.title = "Recommendation"
        downloadAllRecommendation()
    }
    
    func newButtonAction(sender: UIBarButtonItem){
        let recomId = "-1"
        performSegue(withIdentifier: "showEditRecommendation", sender: recomId)
    }
    
    private func setAddButton() {
        
        addButton.frame = CGRect(x: 8, y: 86, width: 300, height: 63)
        //addButton.setImage(UIImage(named: "add2"),for: UIControlState())
        addButton.setBackgroundImage(UIImage(named: "add2"), for: UIControlState())
        addButton.addTarget(self, action: #selector(addRecommendation), for: .touchUpInside)
        addButton.setTitle("         ADD RECOMMENDATIONS", for: [])
        addButton.titleLabel!.font = UIFont(name: "Helvetica Neue", size: 17)
        self.view.addSubview(addButton)
    }
    
    private func removeAddButton() {
        
        addButton.isHidden = true
        
    }
    
    func downloadAllRecommendation () {
        HUD.show(.progress)
        rekomendasi = []
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/cv_part/recommendation"
   
        NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let recommendDictionaries = server_response["data"] as! NSArray
                    
                    for recommendDictionary in recommendDictionaries {
                        let eachRecommend = recommendDictionary as! [String:Any]
                        let id_rekomendasi = eachRecommend ["id_rek"] as? String
                        let id_member = eachRecommend ["id_member"] as? String
                        let nama_rekomendasi = eachRecommend ["nama_rek"] as? String
                        let posisi = eachRecommend ["posisi"] as? String
                        let no_telp = eachRecommend ["no_tlp"] as? String
                        let alamat = eachRecommend ["alamat"] as? String
                        
                        self.rekomendasi.append(Rekomendasi(id_rekomendasi: id_rekomendasi!, id_member: id_member!, nama_rekomendasi: nama_rekomendasi!, posisi: posisi!, no_telp: no_telp!, alamat: alamat!))
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if (self.rekomendasi.count == 0){
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
        if rekomendasi.count == 0 {
            tableView.isHidden = true
            setAddButton()
            return 0
        }   else {
            tableView.isHidden = false
            removeAddButton()
            return rekomendasi.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendCell", for: indexPath) as! recommendCell
        let rekomendasi = self.rekomendasi[indexPath.row]
        
        cell.rekomendasi = rekomendasi
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(Recommendation.edit_recommend(_:)), for: .touchUpInside)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(Recommendation.delete_recommend(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addRecommendation(_ button: UIButton) {
        let recomId = "-1"
        performSegue(withIdentifier: "showEditRecommendation", sender: recomId)
    }
    

    @IBAction func edit_recommend(_ sender: Any) {
        let data = rekomendasi[(sender as AnyObject).tag]
        let recomId = data.id_rekomendasi
        performSegue(withIdentifier: "showEditRecommendation", sender: recomId)
    }
    
    @IBAction func delete_recommend(_ sender: Any) {
        let data = rekomendasi[(sender as AnyObject).tag]
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        let rekomenId = data.id_rekomendasi
        
        deleteRecommendation(indexPath!, rekomenId!)
        
    }
    
    func deleteRecommendation (_ row:IndexPath,_ id:String) {
        
        let url = "http://api.career.undip.ac.id/v1/jobseekers/delete_cv_part/recommendation"
        let paramToSend = "id_data=" + id

        NetworkService.parseJSONFromURL(url, "POST", parameter: paramToSend){ (server_response) in
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                    DispatchQueue.main.async {
                        self.rekomendasi.remove(at: row.row)
                        self.tableView.deleteRows(at: [row], with: .fade)
                        self.downloadAllRecommendation()
                    }
                } else if (status == "error"){
                    let message = server_response["message"] as? String
                    Alert.showMessage(title: "WARNING!", msg: message!)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditRecommendation" {
            let Recom2VC = segue.destination as! EditRecommendation
            let pass = sender as! String
            Recom2VC.passedData = pass
            navigationItem.title = nil
        }
    }

}
