//
//  TaskCreatorViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 8/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import Former

class TaskEditorViewController: FormViewController {
    
    // for private data:
    var currentTask: Task?
    var taskTitle: String = ""
    var desc: String = ""
    var service: Service?
    var workers: [Worker] = []
    var locationTuple: (address: String, latitude: Double, longitude: Double)?
    var dueDate: Date?
    var images: [UIImage] = []
    var taskState: Task.TaskState?
    enum Selector {
        case service
        case workers
        case location
        case pictures
    }
    
    // for UI:
    var locationSelector: LabelRowFormer<FormLabelCell>?
    var pictureSelector: LabelRowFormer<FormLabelCell>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config custom navigation bar items
        setCustomNavigationItem()
        // extract properties
        extractCurrentTask()
        // build editor form
        buildEditor()
    }
    
    // reset select state
    override func viewWillAppear(_ animated: Bool) {
        former.deselect(animated: animated)
    }
    
    @objc func onDonePressed() {
        // create a new task
        saveNewTask()
    }
    
    func setCustomNavigationItem() {
        // set right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(onDonePressed))
        // set back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: nil)
    }
    
    // extract properties from currentTask object
    func extractCurrentTask() {
        if currentTask != nil {
            taskTitle = currentTask!.taskTitle
            desc = currentTask!.taskDesc
            service = currentTask?.service
            locationTuple = (currentTask?.address, currentTask?.latitude, currentTask?.longitude) as? (address: String, latitude: Double, longitude: Double)
            
        }
    }
    
    // build user input entry
    func buildEditor() {
        
        // Section Header creator
        let createHeader : ((String) -> ViewFormer ) = { text in
            return LabelViewFormer<FormLabelHeaderView>().configure {
                $0.text = text
                $0.viewHeight = 44
            }
        }
        
        // Menu creator
        let createMenu : ((String, String, (() -> Void)?) -> RowFormer) = { (text, subText, onSelected) in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.accessoryType = .disclosureIndicator
                }.configure {
                    $0.text = text
                    $0.subText = subText
                }.onSelected({ _ in
                    onSelected?()
                })
        }
        
        // necessary elements: 1.title, 2.desc, 3.service, 4.designated workers, 5.due date, 6.location, 7.ref images
        // MARK: Enter Title
        let titleField = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Task Title"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textField.textColor = .formerSubColor()
            $0.textField.font = .boldSystemFont(ofSize: 14)
            }.configure {
                $0.placeholder = "e.g. "
                $0.text = taskTitle
            }.onTextChanged { (text) in
                self.taskTitle = text
        }
        // MARK: Enter Desc
        let descField = TextViewRowFormer<FormTextViewCell>() {
            $0.titleLabel.text = "Description"
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFont(ofSize: 15)
            }.configure {
                $0.placeholder = "Add Task Introduction"
                $0.text = desc
            }.onTextChanged { (text) in
                // save Task desc
                self.desc = text
        }
        
        // MARK: Select Service: Single Selection
        let serviceSelector = createMenu("💁 Select Service", Static.none_selected) { [weak self] in
            // perform segue here:
            self?.performSegue(withIdentifier: Static.segue_openServicePicker, sender: self)
            } as? LabelRowFormer<FormLabelCell>
        
        // MARK: Pickup Designated Workers: Multi Selection
        let workerSelector = createMenu("👷 Designate Workers", Static.none_selected) { [weak self] in
            // perform segue here:
            self?.performSegue(withIdentifier: Static.segue_openWorkerPicker, sender: self)
            } as? LabelRowFormer<FormLabelCell>
        // MARK: Select Due Date of Task
        let dueDatePicker = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "📆 Select Due Date"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .dateAndTime
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.mediumDateShortTime)
        // MARK: Search Location
        locationSelector = createMenu("📍 Address", Static.not_set) {[weak self] in
            // perform segue here:
            self?.performSegue(withIdentifier: Static.segue_openLocationSelector, sender: self)
            } as? LabelRowFormer<FormLabelCell>
        // MARK: Upload Images
        pictureSelector = createMenu("🖼️ Upload Pictures", Static.not_set) {[weak self] in
            // perform segue here:
            self?.performSegue(withIdentifier: Static.segue_openPicturePicker, sender: self)
            } as? LabelRowFormer<FormLabelCell>
        let sectionBasic = SectionFormer(rowFormer: titleField, descField).set(headerViewFormer: createHeader("Basic Task Info"))
        let sectionSelectors = SectionFormer(rowFormer: serviceSelector!, workerSelector!)
        let sectionLocationSelector = SectionFormer(rowFormer: locationSelector!)
        let sectionUploadPicture = SectionFormer(rowFormer: pictureSelector!)
        let sectionDatePicker = SectionFormer(rowFormer: dueDatePicker)
        former.append(sectionFormer: sectionBasic, sectionSelectors, sectionLocationSelector, sectionUploadPicture, sectionDatePicker)
    }

    func saveNewTask() {
        if currentTask == nil {
            currentTask = Task()
            // set task properties...
            //
            //
            DatabaseService.shared.addNewTask(task: currentTask!)
        }
    }
}

extension TaskEditorViewController {
    // prepare info for different segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Static.segue_openWorkerPicker:
            print("worker")
            break
        case Static.segue_openServicePicker:
            print("service")
            break
        case Static.segue_openLocationSelector:
            let locationSelector = segue.destination as! LocationSelectViewController
            locationSelector.locationTuple = locationTuple
            // set delegate
            locationSelector.delegate = self
            break
        case Static.segue_openPicturePicker:
            let picPicker = segue.destination as! PicPickerViewController
            // assign images
            picPicker.images = self.images
            // set delegate
            picPicker.delegate = self
            break
        default:
            break
        }
    }
}

extension TaskEditorViewController: LocationSelectorDelegate, PicturePickerDelegate {
    // update selector subtext
    func updateSelectorSubText(on selector: Selector, _ selection: Any?) {
        switch selector {
        case .service:
            break
        case .workers:
            break
        case .location:
            let address = selection as? String
            // trim the string
            let subText = Static.trimString(for: address, to: 25, true)
            locationSelector?.subText = subText
            locationSelector?.update()
        case .pictures:
            if let count = selection as? Int {
                let subText = String(format: count > 1 ? "%d Pictures": "%d Picture", count)
                pictureSelector?.subText = subText
                pictureSelector?.update()
            }
        }
    }

    // MARK: - LocationSelectorDelegate
    func onLocationReady(location: (address: String, latitude: Double, longitude: Double)) {
        // update local property: locationTuple
        locationTuple = location
        // update location selector menu
        updateSelectorSubText(on: TaskEditorViewController.Selector.location, location.address)
    }
    
    // MARK: - PicturePickerDelegate
    func onPictureSelectionFinished(images: [UIImage]) {
        // collect images to inner property.
        self.images = images
        // update subtitle for selector menu
        let count = images.count
        
        updateSelectorSubText(on: TaskEditorViewController.Selector.pictures, count)
    }
}