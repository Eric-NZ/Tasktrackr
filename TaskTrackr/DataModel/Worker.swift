//
//  Worker.swift
//  TaskTrackr
//
//  Created by Eric Ho on 4/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import RealmSwift

class Worker: Object {
    // Auto Id
    @objc dynamic var workerId: String = UUID().uuidString
    // Full Name
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    // Job Title
    @objc dynamic var role: String?
    // Join Date
    @objc dynamic var timestamp: Date = Date()
    // Account
    @objc dynamic var username: String = ""
    @objc dynamic var initialPassword: String = ""
    
    // Primary Key
    override static func primaryKey() -> String {
        return "workerId"
    }
}
