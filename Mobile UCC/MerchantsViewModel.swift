//
//  MerchantsViewModel.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 18/05/19.
//  Copyright © 2019 LabSE Siskom. All rights reserved.
//

import Foundation

class MerchantsViewModel: NSObject
{
    var merchants = [Merchant]()
    
    var tableView: UITableView!
    
    init(tableView: UITableView){
        self.tableView = tableView
    }
    
    func requestData(completion: @escaping ()->()) {
        let urlString = "http://api.career.undip.ac.id/v1/merchant/list"
        
        NetworkService.parseJSONFromURL(urlString, "GET", parameter: ""){ (server_response) in
            
            if let status = server_response["status"] as? String {
                if (status == "ok"){
                    let merchantDictionaries = server_response["data"] as! [[String:Any]]
                    let merchantsData = MerchantModel(merchantsArray: merchantDictionaries)
                    
                    self.merchants = merchantsData.merchants
                    
                    completion()
                }
            }
        }
                    
    }
    
}

extension MerchantsViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        if merchants.count > 0 {
            noDataLabel.isHidden = true
            return merchants.count
        } else {
            noDataLabel.text          = "No Merchant"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "merchantCell", for: indexPath) as! merchantCell
        let merchants = self.merchants[indexPath.row]
        
        cell.merchant = merchants
        cell.detailMerchant.tag = indexPath.row
        cell.detailMerchant.addTarget(self, action: #selector(MerchantView.buttonPass(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
