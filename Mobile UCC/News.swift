//
//  News.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/4/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import Foundation

class News
{
    var id: Int?
    var name: String?
    var logo: URL?
    var last_update: String?

    
    init(id: Int, name: String, logo: URL, last_update: String)
    {
        self.id = id
        self.name = name
        self.logo = logo
        self.last_update = last_update
        
    }
    
    init(newsDictionary: [String : Any]) {
        id = newsDictionary["id"] as? Int
        name = newsDictionary["name"] as? String
        // logo URL
        logo = URL(string: newsDictionary["logo"] as! String)
    }
    
    static func downloadAllNews() -> [News]
    {
        var news = [News]()
        
        let url = URL(string: "https://career.undip.ac.id/restapi/employers/")
        let jsonData = try? Data(contentsOf: url!)
        
        if let jsonDictionary = NetworkService.parseJSONFromData(jsonData) {
            let newsDictionaries = jsonDictionary["data"] as! [[String : Any]]
            for newsDictionary in newsDictionaries {
                let newNews = News(newsDictionary: newsDictionary)
                news.append(newNews)
            }
        }
        
        return news
    }
}
