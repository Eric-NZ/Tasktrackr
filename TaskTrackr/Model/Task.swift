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
    var timestamp: Date = Date()
    // task title
    var taskTitle: String?
    // task description
    var taskDesc: String?
    // service
    var service: Service?
    // designate workers
    var workers = List<Worker>()
    // due date
    var dueDate: Date?
    // location
    var address: String?
    // images
    var images: [UIImage] = []
    // task state (5.failed / 4.finished / 3.processing / 2.pending / 1.created)
    var taskState: TaskState = .created
}
