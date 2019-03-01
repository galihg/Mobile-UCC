//
//  ContainerViewController.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 25/11/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import UIKit
import SidebarOverlay

class ContainerViewController: SOContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.menuSide = .left
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController")
    }
}
