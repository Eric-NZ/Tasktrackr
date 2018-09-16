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
        return realm
    }
    
    func getCurrentUser() -> SyncUser {
        return SyncUser.current!
    }
    
    func getModelArray(in product: Product) -> [Model] {
        let realm = getRealm()
        return realm.objects(Model.self).filter("product=%@", product.self).toArray(ofType: Model.self)
    }
    
    func getModels(in product: Product) -> Results<Model> {
        let models = getRealm().objects(Model.self).filter("product=%@", product.self)
        return models
    }
    
    func saveModelList(for product: Product, with modelArray: [Model]) {
        let realm = getRealm()
        // delete all models in the product
        let models = getModels(in: product)
        try! realm.write {
            realm.delete(models)
        }
        // reload
        for model in modelArray {
            try! realm.write {
                realm.add(model)
            }
        }
    }
}
