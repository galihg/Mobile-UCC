//
//  NewsViewModel.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 13/04/19.
//  Copyright © 2019 LabSE Siskom. All rights reserved.
//

import Foundation

class NewsViewModel: NSObject
{
    var news = [News]()

    func requestData(completion: @escaping ()->()) {
        let urlString = "http://api.career.undip.ac.id/v1/news/list"
        
        NetworkService.parseJSONFromURL(urlString, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                if status == "ok" {
                    let dataDictionary = server_response["data"] as! [String:Any]
                    let newsDictionaries = dataDictionary["news"] as! [[String:Any]]
                    let newsData = NewsModel(newsArray: newsDictionaries)
                    
                    self.news = newsData.news

                    DispatchQueue.main.async {
                        completion()
                    }
                    
                }
            }
        }
    }
}

extension NewsViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! newsCell
        let news = self.news[indexPath.row]
        
        cell.news = news
        
        return cell
    }
    
    
}
