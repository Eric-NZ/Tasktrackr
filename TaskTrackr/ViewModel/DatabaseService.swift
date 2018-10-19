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
    
    func logout() {
        for user in SyncUser.all {
            debugPrint("user: \(user.key) - \(user.value)")
            user.value.logOut()
        }
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
    
    public func modelListTo2DArray(from list: List<ProductModel>) -> [[ProductModel]] {
        var matrix: [[ProductModel]] = []
        var products: [Product] = []
        products = list.map({ (model) -> Product in
            return model.product!
        })
        matrix = products.map({ (product) -> [ProductModel] in
            return getModels(in: product).resultToArray(ofType: ProductModel.self)
        })
        
        return matrix
    }
    
    public func toolListToArray(from list: List<Tool>) -> [Tool] {
        var array: [Tool] = []
        array.append(contentsOf: list)
        
        return array
    }
    
    public func workerListToArray(from list: List<Worker>) -> [Worker] {
        var array: [Worker] = []
        array.append(contentsOf: list)
        
        return array
    }
    
    public func objectListToArray(from list: List<Object>) -> [Object] {
        var array: [Object] = []
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
    
    // NOTE: save product models to ProductModel.
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
    
    // add (or update) a service object
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
                realm.add(service, update: false)
            }
        }
    }
    
    // add (or update) a task object
    public func addTask(add task: Task, _ title: String, _ desc: String, workers: [Worker], dueData: Date,
                        locationTuple: (address: String, latitude: Double, longitude: Double),
                        images: [UIImage], taskState: Task.TaskState, update: Bool) {
        let realm = getRealm()
        if update {
            try! realm.write {
                task.workers.removeAll()
                task.workers.append(objectsIn: workers)
                task.setValue(title, forKey: "taskTitle")
                task.setValue(desc, forKey: "taskDesc")
                task.setValue(dueData, forKey: "dueDate")
                task.setValue(locationTuple.address, forKey: "address")
                task.setValue(locationTuple.latitude, forKey: "latitude")
                task.setValue(locationTuple.longitude, forKey: "longitude")
                // image
                //
                task.setValue(taskState, forKey: "taskState")
            }
        } else {
            task.workers.append(objectsIn: workers)
            task.taskTitle = title
            task.taskDesc = desc
            task.dueDate = dueData
            // location
            task.address = locationTuple.address
            task.latitude = locationTuple.latitude
            task.longitude = locationTuple.longitude
            // images
            //
            // progress
//            task.taskState = taskState
            
            try! realm.write {
                realm.add(task, update: false)
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
    
    // destArray(B) is a sub set of source2DArray(A), this function returns an indices where A contains elememts from B
    func mappingSegregatedIndices(wholeMatrix: [[Object]], elements: [Object]) -> [[Int]]{
        var indices: [[Int]] = []
        
        let numberOfSections = wholeMatrix.count
        for section in 0..<numberOfSections {
            indices.append([])
            let numberOfRowsInSection = wholeMatrix[section].count
            for row in 0..<numberOfRowsInSection {
                if elements.contains(wholeMatrix[section][row]) {
                    indices[section].append(row)
                }
            }
        }
        
        return indices
    }
}
