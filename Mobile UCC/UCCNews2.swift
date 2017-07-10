//
//  UCCNews2.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 6/23/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class UCCNews2: BaseViewController {
    
  
    //var passedData2: String!
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    
    var passedData : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.addSlideMenuButton()
        self.title = "UCC News"
        let passedURL = passedData[1]

        let networkService = NetworkService(url: passedURL as! URL)
            networkService.downloadImage({ (imageData) in
                let image = UIImage(data: imageData as Data)
                DispatchQueue.main.async(execute: {
                    self.newsImage.image = image
                })
            })
        
        newsTitle.text = (passedData[0] as! String)
        newsContent.text = (passedData[0] as! String)
        
        //print(passedData[0])
    }

}
