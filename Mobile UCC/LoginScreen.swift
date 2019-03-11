//
//  LoginScreen.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/23/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import KeychainSwift

class LoginScreen: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _login_button: UIButton!
 
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var OuterStackView: UIStackView!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Do any additional setup after loading the view.
        _username.delegate = self
        _password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        
        let auth_uname = _username.text
        let password = _password.text
        let data = password!.data(using: String.Encoding.utf8)
        let auth_passw = data!.base64EncodedString()
        let client_ver = "ios-v1.4"
        
        if(auth_uname == "" || password == "")
        {
            Alert.showMessage(title: "WARNING!", msg: "Enter your username and password first")
        } else {
            DoLogin(auth_uname!, auth_passw, client_ver)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        performSegue(withIdentifier: "showReset", sender: self)
    }
    
    func DoLogin(_ userName:String, _ psw:String, _ client:String)
    {
        HUD.show(.progress)
        let url = URL(string: "http://api.career.undip.ac.id/v1/auth/login")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "auth_uname=" + userName + "&auth_passw=" + psw + "&client_ver=" + client
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
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
                    let user_session = server_response["session_data"] as? NSDictionary
                    let user_token = user_session?["token"] as? String
                    let user_data = server_response["account_data"] as? NSDictionary
                    let user_fullname = user_data?["fullname"] as? String ?? "(Empty)"
                    let user_email = user_data?["email"] as? String ?? "(Empty)"
                    let user_avatar = user_data?["avatar"] as? String ?? "(Empty)"
                    let user_email_verification = user_data?["email_verified"] as? Bool
                    let user_phone = user_data?["phone"] as? String ?? "(Empty)"
                    let user_phone_verification = user_data?["phone_verified"] as? Bool
                    
                    let data_block1 = [user_fullname, user_email, user_avatar, user_email_verification!, user_phone, user_phone_verification!] as [Any]
                    
                    let preferences = UserDefaults.standard
                    preferences.set(data_block1, forKey: "session")
                    
                    self.keychain.set(userName, forKey: "USER_NAME_KEY")
                    self.keychain.set(user_token!, forKey: "USER_TOKEN_KEY")
                    
                    print(data_block1)
                    DispatchQueue.main.async {
                        HUD.hide()
                        
                        NotificationCenter.default.post(name: .reload, object: nil)
                        NotificationCenter.default.post(name: .updatePhoto, object: nil)
                        NotificationCenter.default.post(name: .updateProfileSection, object: nil)
                    
                        //self.openViewControllerBasedOnIdentifier("Home")
                        self.dismiss(animated: true, completion: nil)
                       
                    }
                }
                else if (data_block=="error"){
                    DispatchQueue.main.async {
                        HUD.hide()
                        self.LoginError()
                    }
                }
            }
            
        })
        
        task.resume()
    }
    
    func LoginError()
    {
        Alert.showMessage(title: "WARNING!", msg: "Invalid username or password")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _username.resignFirstResponder()
        _password.resignFirstResponder()
        
        return true
    }
    
  
}
