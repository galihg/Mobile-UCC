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
        
        let viewModel = EventsViewModel(tableView: tableView)
        tableView.dataSource = viewModel
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
        let viewModel = EventsViewModel(tableView: tableView)
        HUD.show(.progress)
        viewModel.requestData {
            self.tableView.reloadData()
            HUD.hide()
        }
    }
    
    /*func downloadAllEvents() {
        HUD.show(.progress)
        
        let urlString = "http://api.career.undip.ac.id/v1/event/list"
        
        NetworkService.parseJSONFromURL(urlString, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let eventsDictionaries = server_response["data"] as! [[String:Any]]
                    
                    for eventsDictionay in eventsDictionaries {
                        let eachEvent = eventsDictionay
                        let name = eachEvent["event_name"] as! String
                        let desc = eachEvent["event_desc"] as! String
                        let desc_full = eachEvent["html_desc"] as! String
                        let location = eachEvent["label_location"] as! String
                        let desc_location = eachEvent["desc_location"] as! String
                        let tgl_event = eachEvent["date_start"] as! String
                        
                        // image URL
                        let small_banner = eachEvent["smallbanner_url"] as? String ?? "nil"
                        let banner =  eachEvent["banner_url"] as? String ?? "nil"
                        
                        self.events.append(Events(name: name, desc: desc, desc_full: desc_full, small_banner: small_banner, banner: banner, location: location, desc_location: desc_location, tgl_event: tgl_event))
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        HUD.hide()
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
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        if events.count > 0 {
            noDataLabel.isHidden = true
            return events.count
        } else {
            noDataLabel.text          = "No Event"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! eventCell
        let events = self.events[indexPath.row]
        
        cell.events = events
        
        return cell
    }*/
    
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

