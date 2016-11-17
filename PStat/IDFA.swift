//
//  IDFA.swift
//  PStat
//
//  Created by media-pt on 08.11.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation
import AdSupport

struct IDFA {
    
    static func detectIDFA() -> String? {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        } else {
            return nil
        }
    }
}
