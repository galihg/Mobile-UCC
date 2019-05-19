//
//  EventsViewModel.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 15/05/19.
//  Copyright © 2019 LabSE Siskom. All rights reserved.
//

import Foundation

class EventsViewModel: NSObject
{
    var events = [Events]()
    
    var tableView: UITableView!
    
    init(tableView: UITableView){
        self.tableView = tableView
    }
    
    func requestData(completion: @escaping ()->()) {
        let urlString = "http://api.career.undip.ac.id/v1/event/list"
        
        NetworkService.parseJSONFromURL(urlString, "GET", parameter: ""){
            (server_response) in
            
            if let status = server_response["status"] as? String {
                if status == "ok" {
                    let dataDictionaries = server_response["data"] as! [[String:Any]]
                    let eventsData = EventsModel(eventsArray: dataDictionaries)
                    
                    self.events = eventsData.events
                    
                    completion()
                    
                }
            }
        }
    }
}

extension EventsViewModel: UITableViewDataSource {
    
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
    }
}
