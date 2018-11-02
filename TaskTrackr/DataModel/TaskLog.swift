//
//  TaskLog.swift
//  TaskTrackr
//
//  Created by Eric Ho on 28/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

class TaskLog: Object {
    // task states
    enum TaskState: Int {
        case created            // 0 - task has just been created, not yet assigned
        case pending            // 1 - task has been assigned but waiting for process
        case processing         // 2 - task has been processing
        case finished           // 3 - task has been finished :)
        case failed             // 4 - task is failed :(
    }
    
    var taskState: TaskState {
        get {
            return TaskState(rawValue: toState)!
        }
        set {
            toState = newValue.rawValue
        }
    }
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var fromState = TaskState.created.rawValue
    @objc dynamic var toState = TaskState.created.rawValue
}
