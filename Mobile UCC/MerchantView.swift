//
//  MerchantView.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class MerchantView: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSlideMenuButton()

        // Do any additional setup after loading the view.

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
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
        let viewModel = MerchantsViewModel(tableView: tableView)
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        viewModel.requestData {
            self.tableView.reloadData()
            HUD.hide()
        }
    }
    
    @IBAction func buttonPass(_ sender: Any) {
         let viewModel = MerchantsViewModel(tableView: tableView)
        
        let data = viewModel.merchants[(sender as AnyObject).tag]
        
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



