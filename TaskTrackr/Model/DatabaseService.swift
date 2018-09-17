//
//  DatabaseService.swift
//  TaskTrackr
//
//  Created by Eric Ho on 3/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}

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
//        let realm = try! Realm()
        return realm
    }
    
    func getCurrentUser() -> SyncUser {
        return SyncUser.current!
    }
    
    // convert an array to a list
    func arrayToList<T>(from array: [T]) -> List<T> {
        let list = List<T>()
        list.append(objectsIn: array)
        
        return list
    }
    
    func getModelArray(in product: Product) -> [Model] {
        let realm = getRealm()
        return realm.objects(Model.self).filter("product=%@", product.self).toArray(ofType: Model.self)
    }
    
    func getModels(in product: Product) -> Results<Model> {
        let models = getRealm().objects(Model.self).filter("product=%@", product.self)
        return models
    }
    
    func saveModels(to product: Product, with modelArray: [Model]) {
        let realm = getRealm()
        // delete all models in the product
        let models = getModels(in: product)
        try! realm.write {
            realm.delete(models)
        }
        // reload
        try! realm.write {
            realm.add(modelArray)
        }
    }
    
    // remove models belong to specific product
    func removeModels(for product: Product) {
        let realm = getRealm()
        let toDeleteModels = realm.objects(Model.self).filter("product=%@", product.self)
        try! realm.write {
            realm.delete(toDeleteModels)
        }
    }
    
    // add a new product
    func addProduct(with product: Product) {
        let realm = getRealm()
        try! realm.write {
            realm.add(product)
        }
    }
    
    // update an existing product
    func updateProduct(for product: Product, with name: String, with desc: String, with models: [Model]) {
        let realm = getRealm()
        try! realm.write {
            product.productName = name
            product.productDesc = desc
            product.models = arrayToList(from: models)
        }
    }
}
