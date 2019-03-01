//
//  MerchantView.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class MerchantView: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var merchant = [Merchant]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSlideMenuButton()

        // Do any additional setup after loading the view.

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
        self.title = "Merchant"
        self.navigationItem.title = "Merchant"
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "session") != nil ) {
            Auth.auth_check()
        }
        
        downloadAllMerchants()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ViewControllers view ist fully loaded and could present further ViewController
        //Here you could do any other UI operations
        if Reachability.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            Alert.showMessage(title: "No Internet Detected", msg: "This app requires an Internet connection")
            
            HUD.hide()
        }
        
    }
 
    func downloadAllMerchants() {
        HUD.show(.progress)
        
        let urlString = "http://api.career.undip.ac.id/v1/merchant/list"
        
        NetworkService.parseJSONFromURL(urlString, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let merchantDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for merchantDictionary in merchantDictionaries {
                        let eachMerchant = merchantDictionary
                        let valid = eachMerchant["date_expired"] as? String ?? ""
                        let id_merchant = eachMerchant["id_merchant"] as! String
                        let name = eachMerchant["name"] as! String
                        let address = eachMerchant["address"] as? String ?? ""
                        let desc = eachMerchant["promo_desc"] as? String ?? ""
                        let joined = eachMerchant["date_registered"] as? String ?? ""
                        let contact = eachMerchant["contact"] as? String ?? ""
                        let email = eachMerchant["email"] as? String ?? ""
                        let web = eachMerchant["website"] as? String ?? ""
                        
                        // image URL
                        let banner = URL(string: eachMerchant["banner_img_url"] as! String)
                        let logo = URL(string: eachMerchant["logo_url"] as! String)
                        
                        self.merchant.append(Merchant(banner: banner!, valid: valid, id_merchant: id_merchant, logo: logo!, name: name, address: address, desc: desc, joined: joined, contact: contact, email: email, web: web))
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                } 
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if merchant.count > 0 {
            return merchant.count
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Tidak ada Merchant"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "merchantCell", for: indexPath) as! merchantCell
        let merchant = self.merchant[indexPath.row]
        
        cell.merchant = merchant
        cell.detailMerchant.tag = indexPath.row
        cell.detailMerchant.addTarget(self, action: #selector(MerchantView.buttonPass(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func buttonPass(_ sender: Any) {
        let data = merchant[(sender as AnyObject).tag]
        
        let merchantName = data.name
        let merchantAddress = data.address
        let merchantLogo = data.logo
        let joined = data.joined
        let merchantContact = data.contact
        let merchantEmail = data.email
        let merchantWeb = data.web
        let merchantValid = data.valid
        let merchantBanner = data.banner
        let merchantPromo = data.desc
        
        let passedArray = [merchantName!, merchantAddress!, merchantLogo!, joined!, merchantContact!, merchantEmail!, merchantWeb!, merchantValid!, merchantBanner!, merchantPromo!] as [Any]
        
        self.performSegue(withIdentifier: "detailMerchant", sender: passedArray)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailMerchant" {
          
            let Merchant2VC = segue.destination as! MerchantView2
            let pass = sender as! [Any]
            Merchant2VC.passedData = pass
            navigationItem.title = nil
            
        }
    }
    

    
    
    
}


