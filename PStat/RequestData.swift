//
//  RequestData.swift
//  PStat
//
//  Created by media-pt on 08.11.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation

struct RequestData {
    
    static func logEvents(urlString: String, eventName: String, connectionType: String, dictionary: [String: Any], completionHandler:((_ succes: Bool, _ info: NSDictionary) -> Void)!) {
        
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let url = NSURL(string: encodedString!)
        let request = NSMutableURLRequest(url:url as! URL)
        request.httpMethod = "POST"
        
        let post = "app_name=\(dictionary["appName"]!)&app_id=\(dictionary["bundleID"]!)&app_version=\(dictionary["version"]!)&device_id=\(dictionary["deviceID"]!)&idfa=\(dictionary["IDFA"]!)&device_model=\(dictionary["deviceModel"]!)&device_vendor=\(dictionary["deviceVendor"]!)&os=\(dictionary["os"]!)&os_version=\(dictionary["osVersion"]!)&event_name=\(eventName)&connection_type=\(connectionType)&gps_lat=\(dictionary["latitude"]!)&gps_lon=\(dictionary["longitude"]!)&parameters=\(dictionary["parameter"]!)"
        let postData = post.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.httpBody = postData
        request.setValue("IOS/\(dictionary["osVersion"]!);lib/\(dictionary["libraryVersion"]!)", forHTTPHeaderField: "User-agent")
        print(post)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if let data = data {
                
                do {
                    
                    let requestData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    completionHandler(true, requestData)
                    
                } catch {
                    
                    print(error)
                    let requestData = NSDictionary()
                    completionHandler(false, requestData)
                    
                }
            } else {
                let requestData = NSDictionary()
                completionHandler(false, requestData)
            }
        })
        
        task.resume()
    }
    
}
