//
//  News.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/4/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import Foundation

struct News
{
    var title: String?
    var ringkasan: String?
    var thumb_image: URL?
    var tgl_post: String?
    var foto: URL?
    var deskripsi: String?
}

class NewsModel
{
    var news = [News]()
    
    init(newsArray: [[String:Any]]) {
        for newsDictionary in newsArray {
            let title = newsDictionary["title"] as? String ?? ""
            let ringkasan = newsDictionary["ringkasan"] as? String ?? ""
            let tgl_post = newsDictionary["tgl_post"] as? String ?? ""
            let deskripsi = newsDictionary["deskripsi"] as? String ?? ""
            
            // image URL
            let thumb_image = URL(string: newsDictionary["thumb_url"] as? String ?? "")
            let foto =  URL(string: newsDictionary["foto"] as? String ?? "")
            
            self.news.append(News(title: title, ringkasan: ringkasan, thumb_image: thumb_image!, tgl_post: tgl_post, foto: foto!, deskripsi: deskripsi))
        }
    }
    
}
