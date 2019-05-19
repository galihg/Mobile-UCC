//
//  UpcomingEvent.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD

class UpcomingEvent: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //var events = [Events]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.addSlideMenuButton()
       
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ViewControllers view ist still not in the window hierarchy
        //This is the right place to do for instance animations on your views subviews
        
        self.title = "Upcoming Event"
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "session") != nil ) {
            Auth.auth_check()
        }
        
        downloadAllEvents()
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
    
    func downloadAllEvents() {
        HUD.show(.progress)
        let viewModel = EventsViewModel(tableView: tableView)
        tableView.dataSource = viewModel
        
        viewModel.requestData {
            self.tableView.reloadData()
            HUD.hide()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailEvent" {
            
            let Event2VC = segue.destination as! DetailEvent
            let pass = sender as! [Any]
            Event2VC.passedData = pass
            navigationItem.title = nil
        }
    }
    
}

extension UpcomingEvent: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = EventsViewModel(tableView: tableView)
        let events = viewModel.events[indexPath.row]
        let eventName = events.name
        let eventBanner = events.banner
        //let URLeventBanner = URL (string: eventBanner!)
        let eventDescription = events.desc_full
        let eventLocation = events.desc_location
        let eventDate = events.tgl_event
        
        let passedArray = [eventName!, eventBanner!, eventDescription!, eventLocation!, eventDate! ] as [Any]
        performSegue(withIdentifier: "detailEvent", sender: passedArray )
    }
}

