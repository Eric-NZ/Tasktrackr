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
    var timestamp: Date = Date()
    // task title
    var taskTitle: String?
    // task description
    var taskDesc: String?
    // service
    var service: Service?
    // images
    var images: [String] = []
}
