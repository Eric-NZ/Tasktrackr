//
//  Tool.swift
//  TaskTrackr
//
//  Created by Eric Ho on 4/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import RealmSwift

class Tool: Object {
    
    // Audo Id
    @objc dynamic var toolId: String = UUID().uuidString
    // Tool Name
    @objc dynamic var toolName: String?
    // Tool Description
    @objc dynamic var toolDesc: String?
    // Actions that can use this tool
//    @objc dynamic var actionsApplied: [String]?
    // Created Date
    @objc dynamic var timestamp: Date = Date()
    
    // Primary Key
    override static func primaryKey() -> String {
        return "toolId"
    }
}
