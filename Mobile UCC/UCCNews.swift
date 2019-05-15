//
//  UCCNews.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class UCCNews: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.addSlideMenuButton()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = viewModel
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
        viewModel.requestData { 
            self.tableView.reloadData()
            HUD.hide()
        }
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

extension UCCNews: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let news = viewModel.news[indexPath.row]
        let newsName = news.title
        let newsPhoto = news.foto
        let newsDescription = news.deskripsi
        let newsDate = news.tgl_post
        
        let passedArray = [newsName!, newsPhoto!, newsDescription!, newsDate!] as [Any]
        
        performSegue(withIdentifier: "detailNews", sender: passedArray)
    }
}
