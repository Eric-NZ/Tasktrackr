//
//  PickupViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 25/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol ProductPickerDelegate {
    func selectionDidFinish(selectedModels: [ProductModel])
}

class ProductPickerViewController: ExpandableSelectorController {
    
    var productPickerDelegate: ProductPickerDelegate?
    
    var products: [Product] = DatabaseService.shared.getObjectArray(objectType: Product.self) as! [Product]
    // NOTE: this is an array includes arrays that include models belong to each specific product.
    var allModelArrays: [[ProductModel]] = []
    var selectedModels: [ProductModel] = []
    // UPDATED: prefer to use selectedModelsMatrix
    var selectModelsMatrix: [[ProductModel]] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure arrow image for expandable table view section
        configureSectionArrow(arrowImage: UIImage(named: "down-arrow")!)
        // datasource
        expandableTableViewDataSource = self
        // initialize right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneTapped))

        // load all models for each product
        allModelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        let indices = DatabaseService.shared.mappingSegregatedIndices(wholeMatrix: allModelArrays, elements: selectedModels)
        setupSelectionMatrixFromIndices(marked: indices)
    }
    
    @objc func onDoneTapped() {
        
        // invoke delegate method
        if productPickerDelegate != nil {
            // calculate selectedProduct Models
            let selectionMatrix = getSelectionMatrix()
            selectedModels = calcSelectionModels(selectionMatrix: selectionMatrix)
            productPickerDelegate?.selectionDidFinish(selectedModels: selectedModels)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func calcSelectionModels(selectionMatrix: [[Bool]]) -> [ProductModel] {
        var models: [ProductModel] = []
        let numberOfProduct = selectionMatrix.count
        for p in 0..<numberOfProduct {
            let numberOfModelsInProduct = selectionMatrix[p].count
            for m in 0..<numberOfModelsInProduct {
                if selectionMatrix[p][m] {
                    models.append(allModelArrays[p][m])
                }
            }
        }
        return models
    }
}

// MARK: - ExpandableTableViewDataSource
extension ProductPickerViewController: ExpandableTableViewDataSource {
    
    func numberOfSections(_ tableView: UITableView) -> Int {
        return products.count
    }
    
    func expandableTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allModelArrays[section].count
        
    }
    
    func expandableTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ModelTableViewCell.ID) ?? UITableViewCell(style: .default, reuseIdentifier: ModelTableViewCell.ID)
        cell.textLabel?.text = allModelArrays[indexPath.section][indexPath.row].modelName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return products[section].productName
    }
}
