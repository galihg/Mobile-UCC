//
//  NetworkService2.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 15/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation

class NetworkService {
    
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    typealias ImageDataHandler = ((Data) -> Void)
    typealias jsonHandler = (([String:Any]) -> Void)
    
    func downloadImage(_ completion: @escaping ImageDataHandler)
    {
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch (httpResponse.statusCode) {
                    case 200:
                        if let data = data {
                            completion(data)
                        }
                    default:
                        print(httpResponse.statusCode)
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        })
        
        dataTask.resume()
    }
    
    static func parseJSONFromURL(_ urlString: String, _ method: String, parameter: String, _ completion: @escaping jsonHandler){
        
        let defaults = UserDefaults.standard
        let session = URLSession.shared
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        
        request.httpMethod = method
        request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
        
        if (defaults.object(forKey: "session") != nil ){
            
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [Any]
            
            let username = preferences[0] as! String
            let token = preferences[1] as! String
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
            if (method == "POST") {
                
                let paramToSend = parameter
                request.httpBody = paramToSend.data(using: String.Encoding.utf8)
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                    
                    guard let _:Data = data else { return }
                    
                    let json:Any?
                    
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: [])
                    }
                    catch {
                        return
                    }
                    
                    guard let server_response = json as? [String:Any] else { return }
                    
                    completion(server_response)
                    
                })
                
                task.resume()
                
            } else {
                
                //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: {
                    (data, response, error) in
                    
                    guard let _:Data = data else { return }
                    
                    let json:Any?
                    
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: [])
                    }
                    catch {
                        return
                    }
                    
                    guard let server_response = json as? [String:Any] else { return }
                    
                    completion(server_response)
                    
                })
                
                task.resume()
            }
                
        } else {
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                    
                guard let _:Data = data else { return }
                    
                let json:Any?
                    
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch {
                    return
                }
                    
                guard let server_response = json as? [String:Any] else { return }
                    
                completion(server_response)
                    
                })
                
            task.resume()
        
        }
    }
}

extension NetworkService
{
    static func parseJSONFromData(_ jsonData: Data?) -> [String : AnyObject]?
    {
        if let data = jsonData {
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
                return jsonDictionary
                
            } catch let error as NSError {
                print("error processing json data: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
