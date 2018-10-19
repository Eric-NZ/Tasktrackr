//
//  DBServiceTool.swift
//  TaskTrackr
//
//  Created by Eric Ho on 20/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

extension DatabaseService {
    
    public func toolListToArray(from list: List<Tool>) -> [Tool] {
        var array: [Tool] = []
        array.append(contentsOf: list)
        
        return array
    }
    
    // update an existing tool
    func updateTool(for tool: Tool, with name: String, with desc: String) {
        let realm = getRealm()
        try! realm.write {
            tool.setValue(name, forKey: "toolName")
            tool.setValue(desc, forKey: "toolDesc")
        }
    }

}
