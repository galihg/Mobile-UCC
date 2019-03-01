//
//  ContactUs.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/27/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class ContactUs: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var btnSubject: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telpTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    let items = ["Info member gold / premium", "Info company member", "Info event"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        self.title = "Contact Us"
        btnSubject.isHidden = true
        nameTextField.isHidden = true
        emailTextField.isHidden = true
        telpTextField.isHidden = true
        messageTextField.isHidden = true
        
        tableView.estimatedRowHeight = 113
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        
        if (defaults.object(forKey: "session") != nil ) {
            Auth.auth_check()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath)
        
        cell.textLabel?.text = self.items[indexPath.row]
        cell.textLabel?.sizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        btnSubject.setTitle(items[indexPath.row], for: [])
    }
    
    @IBAction func btnSubject(_ sender: Any) {
        if (tableView.isHidden == true) {
            tableView.isHidden = false
        }
        else {
            tableView.isHidden = true
        }
    }

}
