//
//  ServerManager.swift
//  giphyApp
//
//  Created by MacBook on 5/21/20.
//  Copyright © 2020 den4iklvivua. All rights reserved.
//

import Foundation
import GiphyUISDK
import GiphyCoreSDK


public class ServerManager {
    public static let shared = ServerManager()
    
    let giphyApiKey: String = "57o2fMznIRQUUtRVCxfPHziRK0aN6uav"
    
    public init() {
        Giphy.configure(apiKey: giphyApiKey)
        print("Inited ServerManager")
    }
    
    public func searchImgByName(name: String, completionHandler: @escaping (_ urls: [String])->Void) {
        let decoder = JSONDecoder()
        guard name.count > 0 else {
            return
        }
        guard let url = URL(string: "https://api.giphy.com/v1/gifs/search?api_key=\(giphyApiKey)&q=\(name)&limit=25&offset=0&rating=R&lang=en") else {
            print("https://api.giphy.com/v1/gifs/search?api_key=\(giphyApiKey)&q=\(name)&limit=25&offset=0&rating=R&lang=en")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print(json)
                let newTemp = try decoder.decode(giphyGetImageResponse.self, from: data!)
                print(newTemp.meta.response_id)
                var array = [String]()
                for img in newTemp.data {
                    print(img.images.original.url)
                    array.append(img.images.original.url)
                }
                completionHandler(array)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completionHandler([""])
            }
        }.resume()
    }
    
    public func sendWebHookToDevs() {
//        https://hooks.slack.com/services/TE6R35M9B/B013VJF4Y9K/7UKEYfgH54lm2Zrn 5VfTQhfh
                guard let url = URL(string: "https://hooks.slack.com/services/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") else {
                    
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                var dict = Dictionary<String, Any>()
                dict = [ "Text" : "Denys Havryliak - https://github.com/Den4ikLvivUA/giphyApp"]
                
                var jsonData = NSData()
                do {
                    jsonData = try JSONSerialization.data(withJSONObject: dict, options: []) as NSData
                    request.httpBody = jsonData as Data
                } catch {
                    print(error.localizedDescription)
                }
                
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(json)
                        
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                        
                    }
                }.resume()
    }
}
