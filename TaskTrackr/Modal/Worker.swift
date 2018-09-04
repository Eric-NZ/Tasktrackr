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
    @objc dynamic var workerName: String?
    // Job Title
    @objc dynamic var workerPosition: String?
    // What Actions this worker can do?
    @objc dynamic var actionsApplied: [String]?
    // Join Date
    @objc dynamic var timestamp: Date = Date()
    
    // Primary Key
    override static func primaryKey() -> String {
        return "workerId"
    }
}
