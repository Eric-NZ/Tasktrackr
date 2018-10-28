//
//  ProductModel.swift
//  TaskTrackr
//
//  Created by Eric Ho on 28/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

class ProductModel: Object {
    
    @objc dynamic var modelId: String = UUID().uuidString
    @objc dynamic var modelName: String?
    @objc dynamic var product: Product?
    
    override static func primaryKey() -> String? {
        return "modelId"
    }
    
}
