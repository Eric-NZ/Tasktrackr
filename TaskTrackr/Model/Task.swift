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
    enum TaskState: Int {
        case created            // 0 - task has just been created, not yet assigned
        case pending            // 1 - task has been assigned but waiting for process
        case processing         // 2 - task has been processing
        case finished           // 3 - task has been finished :)
        case failed             // 4 - task is failed :(
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
    // task state (4.failed / 3.finished / 2.processing / 1.pending / 0.created)
    @objc dynamic var state = TaskState.created.rawValue
    var taskState: TaskState {
        get {
            return TaskState(rawValue: state)!
        }
        set {
            state = newValue.rawValue
        }
    }
    // state change
    var stateChanges = List<TaskStateChange>()
    // workers and managers can add comments at any state of a task
    var comments = List<Comment>()
    
    // Primary Key
    override static func primaryKey() -> String {
        return "taskId"
    }
}

class TaskStateChange: Object {
    var taskState: Task.TaskState {
        get {
            return Task.TaskState(rawValue: currentState)!
        }
        set {
            currentState = newValue.rawValue
        }
    }
    @objc dynamic var changeTime: Date = Date()
    @objc dynamic var lastState = Task.TaskState.created.rawValue
    @objc dynamic var currentState = Task.TaskState.created.rawValue
}
