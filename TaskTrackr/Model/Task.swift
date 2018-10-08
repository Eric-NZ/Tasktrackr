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
        case created
        case pending
        case processing
        case finished
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
    // images
    var images: [UIImage] = []
    // task state (4.Finished / 3.processing / 2.pending / 1.created)
    var taskState: TaskState = .created
}
