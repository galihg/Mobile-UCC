//
//  NetworkService2.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 15/03/18.
//  Copyright © 2018 LabSE Siskom. All rights reserved.
//

import Foundation
import KeychainSwift


typealias ImageDataHandler = ((Data) -> Void)
typealias JSONHandler = (([String:Any]) -> Void)

class NetworkService {
    
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)

    let url: URL
    
    init(url: URL) {
        self.url = url
    }

    func downloadImage(_ completion: @escaping ImageDataHandler)
    {
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch (httpResponse.statusCode) {
                    case 200:
                        if let data = data {
                            DispatchQueue.main.async {
                                completion(data)
                            }
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
    
    /*static func parseJSONFromURL(_ urlString: String, _ method: String, parameter: String, _ completion: @escaping JSONHandler){
        
        let keychain = KeychainSwift()
        let session = URLSession.shared
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.httpMethod = method
        
        request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")

        if (keychain.get("USER_NAME_KEY") != nil && keychain.get("USER_TOKEN_KEY") != nil){
            
            let userName = keychain.get("USER_NAME_KEY")
            let userToken = keychain.get("USER_TOKEN_KEY")
            
            let loginString = String(format: "%@:%@", userName!, userToken!)
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
                    
                    DispatchQueue.main.async {
                        completion(server_response)
                    }
                    
                })
                
                task.resume()
                
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
                    
                    DispatchQueue.main.async {
                        completion(server_response)
                    }
                    
                })
                
                task.resume()
            }
                
        } else {
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
                    
                    DispatchQueue.main.async {
                        completion(server_response)
                    }
                    
                })
                
                task.resume()
                
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
                    
                    DispatchQueue.main.async {
                         completion(server_response)
                    }
                   
                })
                
                task.resume()
            }
        }
    }*/
    
    //New Network Request
    static func parseJSONFromURL(_ urlString: String, _ method: String, parameter: String, _ completion: @escaping JSONHandler){
        
        let keychain = KeychainSwift()
        let session = URLSession.shared
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.httpMethod = method
        
        request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
        
        if (keychain.get("USER_NAME_KEY") != nil && keychain.get("USER_TOKEN_KEY") != nil){
            
            let userName = keychain.get("USER_NAME_KEY")
            let userToken = keychain.get("USER_TOKEN_KEY")
            
            let loginString = String(format: "%@:%@", userName!, userToken!)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
            
        if (method == "POST") {
            let paramToSend = parameter
            request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        }
        
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
            
            DispatchQueue.main.async {
                completion(server_response)
            }
            
        })
        
        task.resume()
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
