//
//  ProductConsumption.swift
//  TaskTrackr
//
//  Created by Eric Ho on 1/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

class ProductConsumption: Object {
    @objc dynamic var timestamp: Date?
    @objc dynamic var productModel: ProductModel?
    @objc dynamic var consumedNumber: Int = 0
    @objc dynamic var alreadyConsumed: Bool = false
}
