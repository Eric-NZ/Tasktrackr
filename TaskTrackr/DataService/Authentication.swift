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
    
    func login(userName: String, password: String, isRegisger: Bool, completion: @escaping ((LoginStatus)->Void)) {
        var loginStatus: LoginStatus = .logged_out
        let cres = SyncCredentials.usernamePassword(username: userName, password: password, register: isRegisger)
        SyncUser.logIn(with: cres, server: Static.AUTH_URL) { (user, error) in
            if let u = user {
                loginStatus = u.isAdmin ? .logged_as_manager : .logged_as_worker
                completion(loginStatus)
            }
        }
    }
}
