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
    var title: String?
    var ringkasan: String?
    var thumb_image: URL?
    var tgl_post: String?
    var foto: URL?
    var deskripsi: String?
    
    init(title: String, ringkasan: String, thumb_image: URL, tgl_post: String, foto: URL, deskripsi: String)
    {
        self.title = title
        self.ringkasan = ringkasan
        self.thumb_image = thumb_image
        self.tgl_post = tgl_post
        self.foto = foto
        self.deskripsi = deskripsi
    }
    
    init(newsDictionary: [String : Any]) {
        title = newsDictionary["title"] as? String
        ringkasan = newsDictionary["ringkasan"] as? String
        tgl_post = newsDictionary["tgl_post"] as? String
        deskripsi = newsDictionary["deskripsi"] as? String
        
        // image URL
        thumb_image = URL(string: newsDictionary["thumb_url"] as! String)
        foto =  URL(string: newsDictionary["foto"] as! String)
    }
    
    /*static func downloadAllNews() -> [News]
    {
        var news = [News]()
        
        let url = URL(string: "http://uat.career.undip.ac.id/restapi/news/list")
        
        let defaults = UserDefaults.standard
        
        if(defaults.object(forKey: "session") != nil)
        {
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [String]
            
            let username = preferences[0]
            let token = preferences[1]
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else
                {
                    return
                }
                
                let json:Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                }
                catch
                {
                    return
                }
                
                
                guard let server_response = json as? [String:Any] else
                {
                    return
                }
                
                
                if let data_block = server_response["status"] as? String
                {
                    
                    
                    if (data_block=="ok") {
                        
                        let newsDictionaries = server_response["data"] as! NSDictionary
                        let newsDictionaries2 = newsDictionaries ["news"] as! [[String : Any]]
                        for newsDictionary in newsDictionaries2 {
                            let newNews = News(newsDictionary: newsDictionary)
                            news.append(newNews)
                            
                        }
                    }
                    else if (data_block=="invalid-session"){
                        print("Error: \(error?.localizedDescription)")
                    }
                }
                
            })
            
            task.resume()
        }
            

        return news
    }*/
    static func downloadAllNews() -> [News]
    {
        var news = [News]()
        
        let url = URL(string: "http://api.career.undip.ac.id/v1/news/list")
        let jsonData = try? Data(contentsOf: url!)
        
        if let jsonDictionary = NetworkService.parseJSONFromData(jsonData) {
            let newsDictionaries = jsonDictionary["data"] as! NSDictionary
            let newsDictionaries2 = newsDictionaries ["news"] as! [[String : Any]]
            for newsDictionary in newsDictionaries2 {
                let newNews = News(newsDictionary: newsDictionary)
                news.append(newNews)
            }
        }
        print(news)
        return news
        
    }
}
