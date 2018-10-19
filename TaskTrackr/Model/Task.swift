//
//  Task.swift
//  TaskTrackr
//
//  Created by Eric Ho on 29/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    // task states
    enum TaskState {
        case created            // task has just been created, not yet assigned
        case pending            // task has been assigned but waiting for process
        case processing         // task has been processing
        case finished           // task has been finished :)
        case failed             // task is failed :(
    }
    
    // task id
    @objc dynamic var taskId: String = UUID().uuidString
    // timestamp
    @objc dynamic var timestamp: Date = Date()
    // task title
    @objc dynamic var taskTitle: String = ""
    // task description
    @objc dynamic var taskDesc: String = ""
    // service
    var service: Service?
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
//    var images: [UIImage] = []
    // task state (5.failed / 4.finished / 3.processing / 2.pending / 1.created)
//    var taskState: TaskState = .created
    
    // Primary Key
    override static func primaryKey() -> String {
        return "taskId"
    }
}
