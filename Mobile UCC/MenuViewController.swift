//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // Profile
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    /**
    *  Array to display menu options
    */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    let defaults = UserDefaults.standard
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
        createObservers()
        NotificationCenter.default.post(name: .reload, object: nil)
        NotificationCenter.default.post(name: .updatePhoto, object: nil)
        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
        
        tblMenuOptions.estimatedRowHeight = tblMenuOptions.rowHeight
        tblMenuOptions.rowHeight = UITableView.automaticDimension
        tblMenuOptions.dataSource = self
        tblMenuOptions.delegate = self
        tblMenuOptions.tableFooterView = UIView()
        tblMenuOptions.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateArrayMenuOptions), name: .reload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getPhoto), name: .updatePhoto, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileSection), name: .updateProfileSection, object: nil)
    }
    
    @objc func getPhoto(_ notification: Notification) {
        if (defaults.object(forKey: "session") != nil) {
            let url = "http://api.career.undip.ac.id/v1/jobseekers/cv"
            NetworkService.parseJSONFromURL(url, "GET", parameter: ""){ (server_response) in
                if let status = server_response["status"] as? String
                {
                    if (status == "ok"){
                        let cvDictionaries = server_response["data"] as! [String:Any]
                        let photoDictionaries = cvDictionaries["profile_photo"] as! [String:Any]
                        let imageThumb = photoDictionaries["thumbnail"] as! String
                    
                        let urlPic = URL (string: imageThumb)
                        let networkService = NetworkService(url: urlPic!)
                        networkService.downloadImage({ (imageData) in
                            let image = UIImage(data: imageData as Data)
                            DispatchQueue.main.async(execute: {
                                self.profPic.image = image
                            })
                        })
                    }
                }
            }
        } else {
            profPic.image = UIImage(named: "avatar")
        }
            
    }
    
    @objc func updateArrayMenuOptions(_ notification: Notification){
        arrayMenuOptions.removeAll()
        
        if (keychain.get("USER_NAME_KEY") != nil && keychain.get("USER_TOKEN_KEY") != nil)
        {
            arrayMenuOptions.append(["title":"Vacancy", "icon":"vacancy_icon"])
            arrayMenuOptions.append(["title":"Upcoming Event", "icon":"event_icon"])
            arrayMenuOptions.append(["title":"UCC News", "icon":"news_icon"])
            arrayMenuOptions.append(["title":"Merchant", "icon":"merchant_icon"])
            arrayMenuOptions.append(["title":"Notification", "icon":"notif_icon"])
            arrayMenuOptions.append(["title":"Application History", "icon":"history_icon"])
            arrayMenuOptions.append(["title":"My CV", "icon":"myCV_icon"])
            arrayMenuOptions.append(["title":"Change Password", "icon":"unlocked"])
            arrayMenuOptions.append(["title":"Contact Us", "icon":"contact_icon"])
            arrayMenuOptions.append(["title":"About", "icon":"about_icon"])
            arrayMenuOptions.append(["title":"Logout", "icon":"logout_icon"])

            tblMenuOptions.reloadData()
        } else {
            arrayMenuOptions.append(["title":"Vacancy", "icon":"vacancy_icon"])
            arrayMenuOptions.append(["title":"Upcoming Event", "icon":"event_icon"])
            arrayMenuOptions.append(["title":"UCC News", "icon":"news_icon"])
            arrayMenuOptions.append(["title":"Merchant", "icon":"merchant_icon"])
            arrayMenuOptions.append(["title":"Contact Us", "icon":"contact_icon"])
            arrayMenuOptions.append(["title":"About", "icon":"about_icon"])
            arrayMenuOptions.append(["title":"Login", "icon":"logout_icon"])
            
            tblMenuOptions.reloadData()
        }
    }
    
    @objc func updateProfileSection() {
        if (defaults.object(forKey: "session") != nil)
        {
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [Any]
            
            fullName.text = (preferences[0] as! String)
            email.text = (preferences[1] as! String)
            email.isHidden = false
        }
        else {
            fullName.text = "Login untuk melihat Profil"
            email.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = Int32(indexPath.row)
        slideMenuItemSelectedAtIndex(index)
        
        if let container = so_containerViewController {
            container.isSideViewControllerPresented = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
 
        let topViewController : UIViewController = self.so_containerViewController!.topViewController!
        
        if (keychain.get("USER_NAME_KEY") != nil && keychain.get("USER_TOKEN_KEY") != nil)
        {
            print("View Controller is : \(topViewController) \n", terminator: "")
            switch(index){
            case 0:
                print("Home\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Home")
                
                break
            case 1:
                print("Upcoming Event\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Upcoming Event")
                
                break
            case 2:
                print("UCC News\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("UCC News")
                
                break
            case 3:
                print("Merchant\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Merchant")
                
                break
                
            case 4:
                print("Notification\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Notification")
                
                break
                
            case 5:
                print("Application History\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Application History")
                
                break
                
            case 6:
                print("My CV\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("My CV")
                
                break
                
            case 7:
                print("Change Password\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Change Password")
                
                break
                
            case 8:
                print("Contact Us\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Contact Us")
                
                break
            case 9:
                print("About\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("About")
                
                break
                
            case 10:
                print("Logout\n", terminator: "")
                HUD.show(.progress)
                let url = URL(string: "http://api.career.undip.ac.id/v1/auth/logout")
                let session = URLSession.shared
                
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "GET"
                
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
                            self.keychain.clear()
                            self.defaults.removeObject(forKey: "session")
                            
                            Alert.showMessage(title: "SUCCESS!", msg: "Anda telah logout")
                            DispatchQueue.main.async {
                                HUD.hide()
                                self.openViewControllerBasedOnIdentifier("Home")
                                
                                NotificationCenter.default.post(name: .updatePhoto, object: nil)
                                NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                                NotificationCenter.default.post(name: .reload, object: nil)
                            }
                        }
                    }
                    
                })
                task.resume()
                
                break
            default:
                print("default\n", terminator: "")
            }
        } else {
            print("View Controller is : \(topViewController) \n", terminator: "")
            switch(index){
            case 0:
                print("Home\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Home")
                
                break
            case 1:
                print("Upcoming Event\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Upcoming Event")
                
                break
            case 2:
                print("UCC News\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("UCC News")
                
                break
            case 3:
                print("Merchant\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Merchant")
                
                break
            
            case 4:
                print("Merchant\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Contact Us")
                
                break
                
            case 5:
                print("About\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("About")
                
                break
                
            case 6:
                print("Login Screen\n", terminator: "")

                //self.openViewControllerBasedOnIdentifier("Login Screen")
                let loginVC = storyboard?.instantiateViewController(withIdentifier: "Login Screen") as! LoginScreen
                self.present(loginVC, animated: true, completion: nil)
                
                break
                
            default:
                print("default\n", terminator: "")
            }
            
        }
    }
}




