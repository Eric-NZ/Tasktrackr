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
    func resultToArray<T>(ofType: T.Type) -> [T] {
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
        case service, worker, product, tool, site
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
    
    private func getModels(in product: Product) -> Results<ProductModel> {
        let models = getRealm().objects(ProductModel.self).filter("product=%@", product.self)
        return models
    }
    
    public func modelListToArray(from list: List<ProductModel>) -> [ProductModel] {
        var array: [ProductModel] = []
        array.append(contentsOf: list)
        
        return array
    }
    
    public func toolListToArray(from list: List<Tool>) -> [Tool] {
        var array: [Tool] = []
        array.append(contentsOf: list)
        
        return array
    }
    
    public func getModelArray(in product: Product) -> [ProductModel] {
        let realm = getRealm()
        return realm.objects(ProductModel.self).filter("product=%@", product.self).resultToArray(ofType: ProductModel.self)
    }
    
    // get object array, this function is not working for model objects.
    public func getObjectArray(objectType: Object.Type) -> [Object] {
        let realm = getRealm()
        return realm.objects(objectType).resultToArray(ofType: objectType)
    }
    
    public func saveModels(to product: Product, with modelArray: [ProductModel]) {
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
    public func removeObject(toRemove: Object) {
        let realm = getRealm()
        try! realm.write {
            realm.delete(toRemove)
        }
    }
    
    // remove objects using key precidate
    public func removeObjects(objectType: Object.Type, with precidate: NSPredicate?) {
        let realm = getRealm()
        let toRemove = realm.objects(objectType).filter(precidate!)
        try! realm.write {
            realm.delete(toRemove)
        }
    }
    
    // add a single object
    public func addObject(for object: Object) {
        let realm = getRealm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    // add / update a service object
    public func addService(add service: Service, _ title: String?, _ desc: String?, tools: [Tool], models: [ProductModel], update: Bool) {
        
        let realm = getRealm()
        
        if update {
            // if update, ensure removeing all tools & models before appending
            try! realm.write {
                service.tools.removeAll()
                service.models.removeAll()
                service.tools.append(objectsIn: tools)
                service.models.append(objectsIn: models)
                service.setValue(title, forKey: "serviceTitle")
                service.setValue(desc, forKey: "serviceDesc")
                
            }
        } else {
            service.tools.append(objectsIn: tools)
            service.models.append(objectsIn: models)
            service.serviceTitle = title
            service.serviceDesc = desc
            
            try! realm.write {
                realm.add(service, update: update)
            }
        }
    }
    
    // update an existing product
    func updateProduct(for product: Product, with name: String, with desc: String, with models: [ProductModel]) {
        let realm = getRealm()
        try! realm.write {
            product.productName = name
            product.productDesc = desc
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
    
    // update an existing object
    func updateObject(for object: Object, with keyValues: [String: String]) {
        let realm = getRealm()
        try! realm.write {
            //
        }
    }
}
