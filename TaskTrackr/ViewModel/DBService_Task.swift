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
    // get Results of Task
    public func getResultsOfTask() -> Results<Task> {
        return getRealm().objects(Task.self).sorted(byKeyPath: "timestamp", ascending: false)
    }
    
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
                // save task state
                changeTaskState(for: task, to: taskState)
                // image
                task.images.removeAll()
                task.images.append(objectsIn: convertImagesToDatas(images: images))
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
            saveImages(to: task, images: images)
            // change task state
            // append first state change to change list for new task
            changeTaskState(for: task, to: Task.TaskState(rawValue: task.state))
            
            try! realm.write {
                realm.add(task, update: false)
            }
        }
    }
    
    private func saveImages(to task: Task, images: [UIImage]) {
        let numberOfImages = images.count
        for n in 0..<numberOfImages {
            // background thread
            if let data: Data = images[n].jpegData(compressionQuality: 0.5) {
                task.images.append(data)
            }
        }
    }
    
    private func convertImagesToDatas(images: [UIImage]) -> [Data] {
        var datas: [Data] = []
        for n in 0..<images.count {
            if let data = images[n].jpegData(compressionQuality: 0.5) {
                datas.append(data)
            }
        }
        return datas
    }
    
    // change task state
    @discardableResult
    public func changeTaskState(for task: Task?, to newState: Task.TaskState?) -> Task.TaskState? {
        guard let task = task else {return nil}

        let lastState = task.state
        // if task state which is not a new task, wasn't changed, nothing to do with it.
        if lastState == newState!.rawValue, lastState != Task.TaskState.created.rawValue {
            return newState
        }
        let realm = getRealm()
        // update state to task
        let taskChange = TaskStateChange()
        taskChange.lastState = lastState
        taskChange.currentState = newState!.rawValue
        
        try! realm.write {
            task.setValue(newState?.rawValue, forKey: "state")
            // append state change to change list
            task.stateChanges.append(taskChange)
        }
        
        return Task.TaskState(rawValue: lastState)
    }
}
