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
    
}
