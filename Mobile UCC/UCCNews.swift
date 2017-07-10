//
//  UCCNews.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import SafariServices

class UCCNews: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var news = [News]()
    var newsName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        news = News.downloadAllNews()
        self.addSlideMenuButton()
        self.title = "UCC News"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
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
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! newsCell
        let news = self.news[indexPath.row]
        
        cell.news = news
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let news = self.news[indexPath.row]
        let newsName = news.name!
        let logoURL = news.logo
        
        //print(newsName)
        let passedArray = [newsName, logoURL!] as [Any]
        performSegue(withIdentifier: "detailNews", sender: passedArray )
        //print(newsName!)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailNews" {
            //var selectedRow = self.tableView.indexPathForSelectedRow
            let News2VC = segue.destination as! UCCNews2
            let pass = sender as! [Any]
            News2VC.passedData = pass
            

        
        }
    }
    
    /*func NewsAtIndexPath(IndexPath: NSIndexPath) -> News2 {
        let pass = news[IndexPath.section]
        return pass.news[IndexPath.row]
    }*/



}
