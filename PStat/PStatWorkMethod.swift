//
//  PStatWorkMethod.swift
//  PStat
//
//  Created by media-pt on 07.11.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation

public class PStat {
    
    private static let libraryVersion = 2.0
    private static let urlString = "http://apps.c8.net.ua/track.php"
    private static let idfa = IDFA.detectIDFA()
    
    public static let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    public static let bundleID = Bundle.main.bundleIdentifier!
    public static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    public static let deviceID = UIDevice.current.identifierForVendor!.uuidString
    public static let deviceModel = UIDevice.current.modelName
    public static let deviceVendor = "Apple"
    public static let os = "IOS"
    public static let osVersion = UIDevice.current.systemVersion
    
    private static var done = false
    private static var db = SQLiteDB.sharedInstance
    
    private static var eventArray = Array<String>()
    private static var parameterArray = Array<String>()
    
    //MARK - Developer Log
    
    public static func enableLogs(log: Bool) {
        if log == true {
            print("Application name: \(PStat.appName)\n", "Bundle identifier: \(PStat.bundleID)\n", "Version: \(PStat.version)\n", "Device identifier: \(PStat.deviceID)\n", "IDFA: \(PStat.idfa!)\n","Device model: \(PStat.deviceModel)\n", "Device vendor: \(PStat.deviceVendor)\n", "Operating system: \(PStat.os)\n", "Operating system version: \(PStat.osVersion)\n")
        }
    }
    
    //MARK: - Log Event
    
    public static func addEvent(eventName: String, parameter: String) {
        
        let cat = Category()
        cat.name = eventName
        cat.param = parameter
        
        if cat.save() != 0 {
            print("save succes")
            setDataToArray()
        } else {
            print("error save")
        }
    }
    
    private static func postMethod() {
        let internetSettings: ConnectionStatus = InternetConnection.checkInternetConnection()
        
        if internetSettings.internetStatus == true {
            
            if done == false && self.eventArray.count != 0 {
                done = true
                Location.registerUserLocation(completionHandler: { (latitude, longitude) in
                    
                    let dictionary: [String: Any] = ["libraryVersion": libraryVersion,
                                                     "IDFA" : idfa!,
                                                     "appName" : appName,
                                                     "bundleID" : bundleID,
                                                     "version" : version,
                                                     "deviceID" : deviceID,
                                                     "deviceModel" : deviceModel,
                                                     "deviceVendor" : deviceVendor,
                                                     "os" : os,
                                                     "osVersion" : osVersion,
                                                     "latitude" : latitude,
                                                     "longitude" : longitude,
                                                     "parameter" : parameterArray[0]]
                    
                    RequestData.logEvents(urlString: urlString, eventName: self.eventArray[0], connectionType: internetSettings.connectionType!, dictionary: dictionary, completionHandler: { (succes, info) in
                        print("succes: \(succes)\n", "info: \(info)")
                        
                        if self.eventArray.count != 0 {
                            done = false
                            self.eventArray.remove(at: 0)
                            self.parameterArray.remove(at: 0)
                            DispatchQueue.main.async {
                                postMethod()
                            }
                        }
                    })
                })
                
            } else {
                print("All Done")
                let result = db.execute(sql: "DELETE FROM categories")
                print(result)
            }
        } else {
            print("Internet connection error")
        }
    }
    
    private static func setDataToArray() {
        
        eventArray = Array<String>()
        parameterArray = Array<String>()
        
        var data = [Category]()
        data = Category.rows(order:"name ASC") as! [Category]
        
        for i in 0..<data.count {
            let cat = data[i]
            eventArray.append(cat.name)
            parameterArray.append(cat.param)
        }
        postMethod()
    }
}
