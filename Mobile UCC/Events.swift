//
//  Events.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import Foundation

struct Events
{
    var name: String?
    var desc: String?
    var desc_full: String?
    var small_banner: String?
    var banner: String?
    var location: String?
    var desc_location: String?
    var tgl_event: String?
    
    /*init(name: String, desc: String, desc_full: String, small_banner: String, banner: String, location: String, desc_location: String, tgl_event: String)
    {
        self.name = name
        self.desc = desc
        self.desc_full = desc_full
        self.small_banner = small_banner
        self.banner = banner
        self.location = location
        self.desc_location = desc_location
        self.tgl_event = tgl_event
    }*/
}

class EventsModel
{
    var events = [Events]()
    
    init(eventsArray: [[String:Any]]) {
        for eventDictionary in eventsArray {
            let name = eventDictionary["event_name"] as! String
            let desc = eventDictionary["event_desc"] as! String
            let desc_full = eventDictionary["html_desc"] as! String
            let location = eventDictionary["label_location"] as! String
            let desc_location = eventDictionary["desc_location"] as! String
            let tgl_event = eventDictionary["date_start"] as! String
            
            // image URL
            let small_banner = eventDictionary["smallbanner_url"] as? String ?? "nil"
            let banner =  eventDictionary["banner_url"] as? String ?? "nil"
            
            self.events.append(Events(name: name, desc: desc, desc_full: desc_full, small_banner: small_banner, banner: banner, location: location, desc_location: desc_location, tgl_event: tgl_event))
        }
    }
}
