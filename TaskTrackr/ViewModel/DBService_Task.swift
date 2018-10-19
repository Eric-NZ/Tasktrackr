//
//  DBService_Task.swift
//  TaskTrackr
//
//  Created by Eric Ho on 20/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//
import Foundation
import RealmSwift

extension DatabaseService {
    // add (or update) a task object
    public func addTask(add task: Task, _ title: String, _ desc: String, service: Service, workers: [Worker], dueData: Date,
                        locationTuple: (address: String, latitude: Double, longitude: Double),
                        images: [UIImage], taskState: Task.TaskState, update: Bool) {
        let realm = getRealm()
        if update {
            try! realm.write {
                task.workers.removeAll()
                task.workers.append(objectsIn: workers)
                task.setValue(service, forKey: "service")
                task.setValue(title, forKey: "taskTitle")
                task.setValue(desc, forKey: "taskDesc")
                task.setValue(dueData, forKey: "dueDate")
                task.setValue(locationTuple.address, forKey: "address")
                task.setValue(locationTuple.latitude, forKey: "latitude")
                task.setValue(locationTuple.longitude, forKey: "longitude")
                task.setValue(taskState.rawValue, forKey: "state")
                // image
                //
            }
        } else {
            task.workers.append(objectsIn: workers)
            task.service = service
            task.taskTitle = title
            task.taskDesc = desc
            task.dueDate = dueData
            // location
            task.address = locationTuple.address
            task.latitude = locationTuple.latitude
            task.longitude = locationTuple.longitude
            // images
            //
            // progress
            task.state = taskState.rawValue
            
            try! realm.write {
                realm.add(task, update: false)
            }
        }
    }
}
