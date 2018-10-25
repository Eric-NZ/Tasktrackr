//
//  Comment.swift
//  TaskTrackr
//
//  Created by Eric Ho on 22/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import RealmSwift

class Comment: Object {
    var content: String = ""
    var author: Worker?
    var atState: Task.TaskState?
}
