//
//  Authentication.swift
//  TaskTrackr
//
//  Created by Eric Ho on 11/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

class Authentication {
    static var shared = Authentication()
    var currentUser: SyncUser?
    
    init() {}
    
    enum LoginStatus: Int {
        case logged_as_worker
        case logged_as_manager
        case logged_out
    }
    
    func logout(complection: (()->Void)?) {
        for user in SyncUser.all {
            debugPrint("user: \(user.key) - \(user.value) is logging out")
            user.value.logOut()
            complection?()
        }
    }
    
    func logIn(userName: String, password: String, completion: @escaping ((LoginStatus)->Void)) {
        var loginStatus: LoginStatus = .logged_out
        let cres = SyncCredentials.usernamePassword(username: userName, password: password, register: false)
        SyncUser.logIn(with: cres, server: Static.AUTH_URL) { (user, error) in
            if let u = user {
                loginStatus = u.isAdmin ? .logged_as_manager : .logged_as_worker
                self.currentUser = user
                DatabaseService.shared.setRealm(for: u)
                completion(loginStatus)
            }
        }
    }
    
    func signUp(userName: String, password: String, complection: @escaping (()->Void)) {
        let cres = SyncCredentials.usernamePassword(username: userName, password: password, register: true)
        SyncUser.logIn(with: cres, server: Static.AUTH_URL) { (user, error) in
            if let u = user {
                u.logOut()
                // assign permission of the managed realm to the user
                let permission = SyncPermission(realmPath: "/TaskTracker", identity: u.identity!, accessLevel: .write)
                print(permission)
                self.currentUser!.apply(permission, callback: { (error) in
                    if let e = error {
                        print(e)
                    } else {
                        // permission successfully applied
                    }
                })
            }
            if let e = error {
                print(e.localizedDescription)
            }
            
            complection()
        }
        
    func matchWorkerByUserName(userName: String) -> Worker? {
        let worker = Worker()
        
        return worker
    }
        
        func getOrganizationalUserByUserName(userName: String) -> SyncUser? {
            if let user = SyncUser.current {
                if user.isAdmin {
                    return user
                } else {
                    
                }
            }
            
            return nil
        }
    }
}
