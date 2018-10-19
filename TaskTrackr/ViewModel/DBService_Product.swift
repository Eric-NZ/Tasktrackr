//
//  DBServiceProduct.swift
//  TaskTrackr
//
//  Created by Eric Ho on 20/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import RealmSwift

extension DatabaseService {
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
    
    public func getModelArray(in product: Product) -> [ProductModel] {
        let realm = getRealm()
        return realm.objects(ProductModel.self).filter("product=%@", product.self).resultToArray(ofType: ProductModel.self)
    }
    
    // update an existing product
    func updateProduct(for product: Product, with name: String, with desc: String, with models: [ProductModel]) {
        let realm = getRealm()
        try! realm.write {
            product.productName = name
            product.productDesc = desc
        }
    }
}
