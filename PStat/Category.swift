//
//  Category.swift
//  PStat
//
//  Created by media-pt on 17.11.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation
import UIKit

class Category: SQLTable {
    
    var id = -1
    var name = ""
    var param = ""
    
    override var description:String {
        return "id: \(id), name: \(name), param: \(param)"
    }
}
