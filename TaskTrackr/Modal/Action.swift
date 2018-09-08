//
//  Action.swift
//  TaskTrackr
//
//  Created by Eric Ho on 4/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import RealmSwift

class Action: Object {
    // Automatic Id
    @objc dynamic var actionId: String = UUID().uuidString
    // Action Title
    @objc dynamic var actionTitle: String?
    // Action Description
    @objc dynamic var actionDesc: String?
//    // Applied Tools
//    @objc dynamic var appliedTools: [String]?
    // Applied Products
//    @objc dynamic var appliedProducts: [String]?
    // Created Date
    @objc dynamic var timestamp: Date = Date()
    
    // Primary Key
    override static func primaryKey() -> String {
        return "actionId"
    }
}
