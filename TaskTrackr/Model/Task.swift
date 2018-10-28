//
//  Task.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import RealmSwift

class Task: Object {
    // task id
    @objc dynamic var taskId: String = UUID().uuidString
    // timestamp
    @objc dynamic var timestamp: Date = Date()
    // task title
    @objc dynamic var taskTitle: String = ""
    // task description
    @objc dynamic var taskDesc: String = ""
    // service
    @objc dynamic var service: Service?
    // designate workers
    var workers = List<Worker>()
    // due date
    @objc dynamic var dueDate: Date = Date()
    // location: address
    @objc dynamic var address: String = ""
    // location: latitude
    @objc dynamic var latitude: Double = 0
    // location: longitude
    @objc dynamic var longitude: Double = 0
    // images
    var images = List<Data>()
    // state loggin
    var stateLogs = List<TaskLog>()
    // workers and managers can add comments at any state of a task
    var comments = List<Comment>()
    
    // Primary Key
    override static func primaryKey() -> String {
        return "taskId"
    }
}
