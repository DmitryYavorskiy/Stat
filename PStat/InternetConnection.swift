//
//  InternetConnection.swift
//  Parse Data test
//
//  Created by media-pt on 11.10.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation
import CoreTelephony

typealias ConnectionStatus = (internetStatus: Bool, connectionType: String?)

struct InternetConnection {
    
    //MARK: - Check Internet Connection
    
    static func checkInternetConnection() -> ConnectionStatus {
        
        let reachability = Reachability()!
        reachability.stopNotifier()
        
        let status = reachability.currentReachabilityStatus
        
        if status == Reachability.NetworkStatus.notReachable {
            return (false, nil)
        } else {
            let currentConnection = InternetConnection.connectionType(status: status)
            return (true, currentConnection)
        }
    }
    
    //MARK: - Connection Type
    
    private static func connectionType(status: Reachability.NetworkStatus) -> String {
        if status == .reachableViaWiFi {
            return "WIFI"
        } else if status == .reachableViaWWAN {
            let telephonyInfo = CTTelephonyNetworkInfo()
            let currentRadio = telephonyInfo.currentRadioAccessTechnology
            return InternetConnection.telephonyNetworkInfo(currentRadio: currentRadio!)
        } else {
            return "Unknown connect"
        }
    }
    
    //MARK: - Telephony Network Info
    
    private static func telephonyNetworkInfo(currentRadio: String) -> String {
        if currentRadio == CTRadioAccessTechnologyEdge {
            return "EDGE"
        } else {
            return "3G"
        }
    }
}
