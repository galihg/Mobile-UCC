//
//  Events.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/5/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import Foundation

class Events
{
    var name: String?
    var desc: String?
    var desc_full: String?
    var small_banner: String?
    var banner: String?
    var location: String?
    var desc_location: String?
    var tgl_event: String?
    
    init(name: String, desc: String, desc_full: String, small_banner: String, banner: String, location: String, desc_location: String, tgl_event: String)
    {
        self.name = name
        self.desc = desc
        self.desc_full = desc_full
        self.small_banner = small_banner
        self.banner = banner
        self.location = location
        self.desc_location = desc_location
        self.tgl_event = tgl_event
    }
    
    /*init(eventsDictionary: [String : Any]) {
        name = eventsDictionary["event_name"] as? String
        desc = eventsDictionary["event_desc"] as? String
        desc_full = eventsDictionary["html_desc"] as? String
        location = eventsDictionary["label_location"] as? String
        desc_location = eventsDictionary["desc_location"] as? String
        tgl_event = eventsDictionary["date_start"] as? String
        
        // image URL
        small_banner = eventsDictionary["smallbanner_url"] as? String ?? "nil"
        banner =  eventsDictionary["banner_url"] as? String ?? "nil"
    }*/
    
}
