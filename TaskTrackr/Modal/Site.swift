//
//  Site.swift
//  TaskTrackr
//
//  Created by Eric Ho on 4/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import RealmSwift

class Site: Object {
    
    // Auto Id
    @objc dynamic var siteId: String = UUID().uuidString
    // Site Title
    @objc dynamic var siteTitle: String?
    // Site Address
    @objc dynamic var siteAddress: String?
    // Latitude in Map
    var latitude: Double?
    // Longitude in Map
    var longitude: Double?
    // Contact Name
    @objc dynamic var contactName: String?
    // Telephone Numer
    @objc dynamic var contactNumber: String?
    // Created Date
    @objc dynamic var timestamp: Date = Date()
    
    override static func primaryKey() -> String {
        return "siteId"
    }
}
