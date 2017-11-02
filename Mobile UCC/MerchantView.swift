//
//  MerchantView.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class MerchantView: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // View which contains the loading text and the spinner
    let loadingView = UIView()
    
    // Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    var merchant = [Merchant]()
    let url = URL(string: "http://api.career.undip.ac.id/v1/auth/check")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSlideMenuButton()
        self.title = "Merchant"
        // Do any additional setup after loading the view.
        
        merchant = Merchant.downloadAllMerchant()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        //let defaults = UserDefaults.standard
        //if(defaults.object(forKey: "session") != nil)
        if(true)
        {
            /*let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
            
            let username = preferences[0]
            let token = preferences[1]
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()*/
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else
                {
                    return
                }
                
                let json:Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch
                {
                    return
                }
                
                
                guard let server_response = json as? [String:Any] else
                {
                    return
                }
                
                
                if let data_block = server_response["status"] as? String
                {
                    
                    
                    if (data_block=="ok") {
                        
                        DispatchQueue.main.async (
                            execute:self.LoginDone
                            
                        )
                    }
                    /*else if (data_block=="invalid-session"){
                        DispatchQueue.main.async (
                            execute:self.LoginError
                        )
                    }*/
                }
                
            })
            
            task.resume()
        }
            
        else
        {
            self.openViewControllerBasedOnIdentifier("Login Screen")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
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
            let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            controller.addAction(ok)
            controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    func LoginDone() {
        return
    }
    
    func LoginError() {
        self.openViewControllerBasedOnIdentifier("Login Screen")
    }
    
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 30
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2.3) - (width / 30.5)
        let y = (tableView.frame.height / 2.3) - (height / 2.3) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
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
        return merchant.count
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
        
        let merchantId = data.id_merchant
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
        
        setLoadingScreen()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let passedArray = [merchantName!, merchantAddress!, merchantLogo!, joined!, merchantContact!, merchantEmail!, merchantWeb!, merchantValid!, merchantBanner!, merchantPromo!] as [Any]
        
        self.performSegue(withIdentifier: "detailMerchant", sender: passedArray)
        
        //let idString = "\(merchantId!)"
        //let urlString = "http://api.career.undip.ac.id/v1/merchant/list/detail/" + idString
        

        //detailMerchant(urlString)
    }
    
    /*func detailMerchant (_ url:String) {
        
        let url = URL(string: url)
        
        //let defaults = UserDefaults.standard
        //if(defaults.object(forKey: "session") != nil)
        if(true)
        {
            /*let preference_block = defaults.object(forKey: "session")
             var preferences = preference_block as! [String]
             
             let username = preferences[0]
             let token = preferences[1]
             
             let loginString = String(format: "%@:%@", username, token)
             let loginData = loginString.data(using: String.Encoding.utf8)!
             let base64LoginString = loginData.base64EncodedString()*/
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else
                {
                    return
                }
                
                let json:Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch
                {
                    return
                }
                
                
                guard let server_response = json as? [String:Any] else
                {
                    return
                }
                
                
                if let data_block = server_response["status"] as? String
                {
                    
                    
                    if (data_block=="ok") {
                        let data1 = server_response["data"] as? NSDictionary
                        let merchantName = data1?["name"] as? String
                        let merchantAddress = data1?["address"] as? String
                        let merchantLogo = data1?["logo_url"] as? String
                        let joined = data1?["date_registered"] as? String ?? "nil"
                        let merchantContact = data1?["contact"] as? String ?? "nil"
                        let merchantEmail = data1?["email"] as? String ?? "nil"
                        let merchantWeb = data1?["website"] as? String ?? "nil"
                        
                        let merchantValid = data1?["date_expired"] as? String
                        let merchantBanner = data1?["banner_img_url"] as? String
                        let merchantPromo = data1?["promo_desc"] as? String
                        
                        
                        let passedArray = [merchantName!, merchantAddress!, merchantLogo!, joined, merchantContact, merchantEmail, merchantEmail, merchantWeb, merchantValid!, merchantBanner!, merchantPromo!] as [Any]
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "detailMerchant", sender: passedArray)
                        }
                        
                    }
                    else if (data_block=="invalid-session"){
                        DispatchQueue.main.async (
                            execute:self.LoginError
                        )
                    }
                }
                
            })
            
            task.resume()
        }
            
        else
        {
            self.openViewControllerBasedOnIdentifier("Login Screen")
        }
    }*/
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailMerchant" {
            removeLoadingScreen()
            UIApplication.shared.endIgnoringInteractionEvents()
            let Merchant2VC = segue.destination as! MerchantView2
            let pass = sender as! [Any]
            Merchant2VC.passedData = pass
            navigationItem.title = nil
            
        }
    }
    

    
    
    
}


