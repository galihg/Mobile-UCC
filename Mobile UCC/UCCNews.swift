//
//  UCCNews.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class UCCNews: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
  
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.addSlideMenuButton()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews

        self.navigationItem.title="UCC News"
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "session") != nil ) {
            Auth.auth_check()
        }
        
        downloadAllNews()
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
            Alert.showMessage(title: "No Internet Detected", msg: "This app requires an Internet connection")
            
            HUD.hide()
        }
    }
    
    func downloadAllNews() {
        HUD.show(.progress)
        
        let urlString = "http://api.career.undip.ac.id/v1/news/list"
        
        NetworkService.parseJSONFromURL(urlString, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let dataDictionary = server_response["data"] as! [String:Any]
                    let newsDictionaries = dataDictionary["news"] as! [[String:Any]]
                    
                    for newsDictionary in newsDictionaries {
                        let eachNews = newsDictionary
                        let title = eachNews["title"] as? String
                        let ringkasan = eachNews["ringkasan"] as? String
                        let tgl_post = eachNews["tgl_post"] as? String
                        let deskripsi = eachNews["deskripsi"] as? String
                        
                        // image URL
                        let thumb_image = URL(string: eachNews["thumb_url"] as! String)
                        let foto =  URL(string: eachNews["foto"] as! String)
                        
                        self.news.append(News(title: title!, ringkasan: ringkasan!, thumb_image: thumb_image!, tgl_post: tgl_post!, foto: foto!, deskripsi: deskripsi!))
                    }
                    
                    DispatchQueue.main.async {
                        HUD.hide()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
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
        let newsName = news.title
        let newsPhoto = news.foto
        let newsDescription = news.deskripsi
        let newsDate = news.tgl_post
        
        let passedArray = [newsName!, newsPhoto!, newsDescription!, newsDate!] as [Any]

        performSegue(withIdentifier: "detailNews", sender: passedArray )
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailNews" {
            
            let News2VC = segue.destination as! UCCNews2
            let pass = sender as! [Any]
            News2VC.passedData = pass
            navigationItem.title = nil
        
        }
    }



}
