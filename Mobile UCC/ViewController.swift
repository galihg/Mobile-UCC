//
//  ViewController.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource: QuotesDataSource
    
    required init?(coder aDecoder: NSCoder) {
        let quotes = [
            Quote(author: "Albert Einstein", text: "Two things are infinite: the universe and human stupidity; and I am not sure about the universe.", gambar: UIImage(named:"poyo.png")!),
            Quote(author: "Steve Jobs", text: "Design is not just what it looks like and feels like. Design is how it works.", gambar: UIImage(named:"poyo.png")!),
            Quote(author: "John Lennon", text: "Life is what happens when you’re busy making other plans.", gambar: UIImage(named:"poyo.png")!)
        ]
        self.dataSource = QuotesDataSource(quotes: quotes)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addSlideMenuButton()
        tableView.estimatedRowHeight = 113
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    

}



