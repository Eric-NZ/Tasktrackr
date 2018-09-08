//
//  DatabaseService.swift
//  TaskTrackr
//
//  Created by Eric Ho on 3/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseService {
    static var shared = DatabaseService()
    
    enum objectType {
        case action, worker, product, tool, site
    }
    
    init() {
        
    }
    
    func getRealmConfig() -> Realm.Configuration {
        let realmConfig = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL))
        
        return realmConfig
    }
    
    func getRealm() -> Realm {
        let realm = try! Realm(configuration: DatabaseService.shared.getRealmConfig())
        return realm
    }
    
    func getCurrentUser() -> SyncUser {
        return SyncUser.current!
    }
    
//    func retriveAllUsers() -> [[String: SyncUser]] {
//        var users = [[String: SyncUser]]()
//        for user in SyncUser.all {
//            debugPrint("user: \(user.key) - \(user.value)")
//            users.append(user)
//        }
//        return users
//    }
}
