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
        let realmConfig = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Static.REALM_URL))
        
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
    
    /** Once data changed, controller will be notified.
     */
    func addNotificationHandle<T>(objects: Results<T>, tableView: UITableView?) -> NotificationToken {
        
        let notificationToken = objects.observe { (changes) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView!.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView!.beginUpdates()
                tableView!.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                      with: .automatic)
                tableView!.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                      with: .automatic)
                tableView!.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                      with: .automatic)
                tableView!.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        return notificationToken
    }
    
    func getModelArray(in product: Product) -> [Model] {
        let realm = getRealm()
        return realm.objects(Model.self).filter("product=%@", product.self).toArray(ofType: Model.self)
    }
    
    private func getModels(in product: Product) -> Results<Model> {
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
    
    // remove a single object
    func removeObject(toRemove: Object) {
        let realm = getRealm()
        try! realm.write {
            realm.delete(toRemove)
        }
    }
    
    // remove objects using key precidate
    func removeObjects(objectType: Object.Type, with precidate: NSPredicate?) {
        let realm = getRealm()
        let toRemove = realm.objects(objectType).filter(precidate!)
        try! realm.write {
            realm.delete(toRemove)
        }
    }
    
    // add a single object
    func addObject(for object: Object) {
        let realm = getRealm()
        try! realm.write {
            realm.add(object)
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
    
    // update an existing tool
    func updateTool(for tool: Tool, with name: String, with desc: String) {
        let realm = getRealm()
        try! realm.write {
            tool.setValue(name, forKey: "toolName")
            tool.setValue(desc, forKey: "toolDesc")
        }
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
    
//    // update an existing object
    func updateObject(for object: Object, with keyValues: [String: String]) {
        let realm = getRealm()
        try! realm.write {
            //
        }
    }
}
