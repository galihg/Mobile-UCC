//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "session") != nil)
        {
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
            
            fullName.text = preferences[2]
            email.text = preferences[3]
            
            let urlPic = URL(string: preferences[4])
            if let Pic = urlPic {
                let networkService = NetworkService(url: Pic)
                networkService.downloadImage({ (imageData) in
                    let image = UIImage(data: imageData as Data)
                    DispatchQueue.main.async(execute: {
                        self.profPic.image = image
                    })
                })
            }
        }
        else {
            fullName.text = "Login untuk melihat Profil"
            email.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        let defaults = UserDefaults.standard
        
        if(defaults.object(forKey: "session") != nil)
        {
            arrayMenuOptions.append(["title":"Vacancy", "icon":"vacancy_icon"])
            arrayMenuOptions.append(["title":"Upcoming Event", "icon":"event_icon"])
            arrayMenuOptions.append(["title":"UCC News", "icon":"news_icon"])
            arrayMenuOptions.append(["title":"Merchant", "icon":"merchant_icon"])
            arrayMenuOptions.append(["title":"Notification", "icon":"notif_icon"])
            arrayMenuOptions.append(["title":"Application History", "icon":"history_icon"])
            //arrayMenuOptions.append(["title":"My CV", "icon":"PlayIcon"])
            arrayMenuOptions.append(["title":"Contact Us", "icon":"contact_icon"])
            arrayMenuOptions.append(["title":"About", "icon":"about_icon"])
            arrayMenuOptions.append(["title":"Logout", "icon":"logout_icon"])
        
        
            tblMenuOptions.reloadData()
        } else {
            arrayMenuOptions.append(["title":"Vacancy", "icon":"vacancy_icon"])
            arrayMenuOptions.append(["title":"Upcoming Event", "icon":"event_icon"])
            arrayMenuOptions.append(["title":"UCC News", "icon":"news_icon"])
            arrayMenuOptions.append(["title":"Merchant", "icon":"merchant_icon"])
            arrayMenuOptions.append(["title":"About", "icon":"about_icon"])
            arrayMenuOptions.append(["title":"Login", "icon":"logout_icon"])
            
            tblMenuOptions.reloadData()
        }
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*if indexPath.section == 0 {
            if let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellProfile")!
            
         
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.backgroundColor = UIColor.clear
            
            return cell
            
           }
        else {
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.backgroundColor = UIColor.clear
            
            let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
            let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
            
            imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
            lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
            
            return cell
        }*/
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
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
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
