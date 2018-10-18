//
//  PickupViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 25/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

protocol ModelPickupDelegate {
    func finishSelection(selectedModels: [ProductModel])
}

class ProductPickerViewController: ExpandableSelectorController {
    
    var pickupDelegate: ModelPickupDelegate?
    
    var products: [Product] = DatabaseService.shared.getObjectArray(objectType: Product.self) as! [Product]
    // NOTE: this is an array includes arrays that include models belong to each specific product.
    var allModelArrays: [[ProductModel]] = []
    var selectedModels: [ProductModel] = []
    // UPDATED: prefer to use selectedModelsMatrix
    var selectModelsMatrix: [[ProductModel]] = []
    
    // this 2-dimension array has the same structure as array allModelArrays
    var modelBoolArrays: [[Bool]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure arrow image for expandable table view section
        configureSectionArrow(arrowImage: UIImage(named: "down-arrow")!)
        // datasource
        expandableTableViewDataSource = self
        // initialize right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDonePressed))

        // load all models for each product
        allModelArrays = products.map({
            return DatabaseService.shared.getModelArray(in: $0)
        })
        
        let indices = DatabaseService.shared.mappingSegregatedIndices(wholeMatrix: allModelArrays, elements: selectedModels)
        initMarkStates(marked: indices)
    }
    
    /** append selected models using both modelBoolArrays and allModalArrays(2-dimension array)
        append selected tools
    */
    func collectSelection() {
        // NOTE: make sure the arrays are empty before append
        selectedModels.removeAll()
        
        for i in modelBoolArrays.indices {
            for j in modelBoolArrays[i].indices {
                if modelBoolArrays[i][j] == true {
                    selectedModels.append(allModelArrays[i][j])
                }
            }
        }
    }
    
    @objc func onDonePressed() {
        // collect selected tools & models
        collectSelection()
        
        // invoke delegate method
        if pickupDelegate != nil {
            pickupDelegate?.finishSelection(selectedModels: selectedModels)
        }
        
        navigationController?.popViewController(animated: true)
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
