//
//  Service.swift
//  TaskTrackr
//
//  Created by Eric Ho on 4/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import RealmSwift

class Service: Object {
    // Automatic Id
    @objc dynamic var serviceId: String = UUID().uuidString
    // Service Title
    @objc dynamic var serviceTitle: String?
    // Service Description
    @objc dynamic var serviceDesc: String?
    // Applicable Tools
    var tools = List<Tool>()
    // Applicable Product models
    var models = List<ProductModel>()
    // Created Date
    @objc dynamic var timestamp: Date = Date()
    
    // Primary Key
    override static func primaryKey() -> String {
        return "serviceId"
    }
}
