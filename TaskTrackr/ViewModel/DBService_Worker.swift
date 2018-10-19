//
//  DBServiceWorker.swift
//  TaskTrackr
//
//  Created by Eric Ho on 20/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

extension DatabaseService {
    
    public func workerListToArray(from list: List<Worker>) -> [Worker] {
        var array: [Worker] = []
        array.append(contentsOf: list)
        
        return array
    }
    
    // update an existing worker
    func updateWorker(for worker: Worker, with firstName: String, with lastName: String, with role: String) {
        let realm = getRealm()
        try! realm.write {
            worker.setValue(firstName, forKey: "firstName")
            worker.setValue(lastName, forKey: "lastName")
            worker.setValue(role, forKey: "role")
        }
    }
    
}
