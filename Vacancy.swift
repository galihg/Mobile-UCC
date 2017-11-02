//
//  Vacancy.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 8/7/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//
/*
import Foundation


class Vacancy
{
    var vacancy_id: Int?
    var company_name: String?
    var company_logo: URL?
    var total_vacancy: Int?

    
    init(company_name: String, job_position: String, company_logo: URL, id_vacancy: Int)
    {
        self.company_name = company_name
        self.job_position = job_position
        self.company_logo = company_logo
        self.id_vacancy = id_vacancy

    }
    
    init(vacancyDictionary: [String : Any]) {
        company_name = vacancyDictionary["offer_company"] as? String
        job_position = vacancyDictionary["offer_name"] as? String
        id_vacancy = vacancyDictionary["id_offer"] as? Int
        
        
        // image URL
        company_logo = URL(string: vacancyDictionary["offer_company_logo"] as! String)
    }
    
    class func downloadAllVacancy() -> [Vacancy]    //(completionHandler: @escaping (_ Vacancy: NSArray) -> ())
    {
        var vacancy = [Vacancy]()
        
        let url = URL(string: "http://uat.career.undip.ac.id/restapi/employers")
 
        /*let defaults = UserDefaults.standard
        
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
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
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
                        do {
                        let vacancyDictionaries = server_response["data"] as! [[String : Any]]
                        //print(vacancyDictionaries)
                       
                        for vacancyDictionary in vacancyDictionaries {
                                let newVacancy = Vacancy(vacancyDictionary: vacancyDictionary)
                                vacancy.append(newVacancy)
                            }
                        
                        //print(vacancy)
                        completionHandler(vacancy as NSArray)
                        }
                    }
                    else if (data_block=="invalid-session"){
                       print("Error: \(String(describing: error?.localizedDescription))")
                    }
                   
                }
                
            })
            
            task.resume()
           
        }
            
        else
        {
             print("Error")
        }*/
        
        let jsonData = try? Data(contentsOf: url!)
        
        if let jsonDictionary = NetworkService.parseJSONFromData(jsonData) {
            let vacancyDictionaries = jsonDictionary["data"] as! [[String : Any]]
            for vacancyDictionary in vacancyDictionaries {
                let newVacancy = Vacancy(vacancyDictionary: vacancyDictionary)
                vacancy.append(newVacancy)
                
            }
            
            
        }
        
        return vacancy
    }
}*/
