//
//  QuotesDataSource.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/28/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

class QuotesDataSource: NSObject {
    
    let quotes: [Quote]
    
    init(quotes: [Quote]) {
        self.quotes = quotes
    }
}

extension QuotesDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: vacancyCell.self)) as! vacancyCell
        let quote = quotes[indexPath.row]
        cell.author = quote.author
        cell.quote = quote.text
        cell.gambar = quote.gambar
        return cell
    }
}
