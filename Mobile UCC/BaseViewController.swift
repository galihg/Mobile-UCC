//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import PKHUD
class BaseViewController: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let defaults = UserDefaults.standard
        
        if(defaults.object(forKey: "session") != nil)
        {
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
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
            print("Login Screen\n", terminator: "")
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
                        let preferences = UserDefaults.standard
                        preferences.removeObject(forKey: "session")
                        DispatchQueue.main.async {
                            HUD.hide()
                            self.openViewControllerBasedOnIdentifier("Home")
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
            let topViewController : UIViewController = self.navigationController!.topViewController!
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
                print("About\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("About")
                
                break
                
            case 5:
                print("Login Screen\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Login Screen")
                
                break
                
                
            default:
                print("default\n", terminator: "")
            }
            
        }
        
    }
    
    func backtoLogin()
    {
        self.openViewControllerBasedOnIdentifier("Login Screen")
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
}
