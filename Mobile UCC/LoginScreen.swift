//
//  LoginScreen.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 7/23/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit


class LoginScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _login_button: UIButton!
 
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var bottomConstraintConstant:CGFloat = 100.0
    
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var OuterStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Do any additional setup after loading the view.
        _username.delegate = self
        _password.delegate = self
        
        // Listen for the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        
        let auth_uname = _username.text
        let password = _password.text
        let data = password!.data(using: String.Encoding.utf8)
        let auth_passw = data!.base64EncodedString()
        let client_ver = "ios-v1.1"
        
        if(auth_uname == "" || password == "")
        {
            createAlert(title: "WARNING!", message: "Masukkan Username dan Password terlebih dahulu")
        }
        
        DoLogin(auth_uname!, auth_passw, client_ver)
    }
    
    
    func DoLogin(_ user:String, _ psw:String, _ client:String)
    {
        let url = URL(string: "http://api.career.undip.ac.id/v1/auth/login")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "auth_uname=" + user + "&auth_passw=" + psw + "&client_ver=" + client
        
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
                    let data1 = server_response["session_data"] as? NSDictionary
                    let data2 = data1?["token"] as? String
                    let data3 = server_response["account_data"] as? NSDictionary
                    let data4 = data3?["fullname"] as? String ?? "(Empty)"
                    let data5 = data3?["email"] as? String ?? "(Empty)"
                    let data6 = data3?["avatar"] as? String ?? "(Empty)"
                    let data7 = data3?["email_verified"] as? Bool
                    let data8 = data3?["phone"] as? String ?? "(Empty)"
                    let data9 = data3?["phone_verified"] as? Bool
                    
                    let data_block1 = [user, data2!, data4, data5, data6, data7!, data8, data9!] as [Any] 
                    
                    let preferences = UserDefaults.standard
                    preferences.set(data_block1, forKey: "session")
                    print(data_block1)
                    DispatchQueue.main.async (
                        execute:self.LoginDone
                        
                    )
                }
                else if (data_block=="error"){
                    DispatchQueue.main.async (
                        execute:self.LoginError
                    )
                }
            }
            
        })
        
        task.resume()
    }
    

    func LoginDone() {

        self.performSegue(withIdentifier: "LoggedIn", sender: self)
    }
    
    func LoginError()
    {
        createAlert(title: "WARNING!", message: "Invalid username or password.")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        _username.resignFirstResponder()
        _password.resignFirstResponder()
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            
            self.bottomConstraint.constant = self.bottomConstraintConstant
            self.view.layoutIfNeeded()
            
        })
        
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _username.resignFirstResponder()
        _password.resignFirstResponder()
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            
            self.bottomConstraint.constant = self.bottomConstraintConstant
            self.view.layoutIfNeeded()
            
        })
    }
    
    func keyboardWillShow(notification:NSNotification) {
        
        if let info = notification.userInfo {
            
            let rect:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            // Find our target Y
            let targetY = view.frame.size.height - rect.height - 30 - _username.frame.size.height
            
            // Find out where the stackview is relative to the frame
            let textFieldY = OuterStackView.frame.origin.y + textFieldStackView.frame.origin.y 
            
            let difference =  textFieldY + targetY
            
            let targetOffsetForTopConstraint = bottomConstraint.constant + difference
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.bottomConstraint.constant = targetOffsetForTopConstraint
                self.view.layoutIfNeeded()
                
            })
            
        }
        
        
        
    }
}
