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
    var selectedWorkers: [Worker] = []
    var locationTuple: (address: String, latitude: Double, longitude: Double)?
    var dueDate: Date?
    var images: [UIImage] = []
    var taskState: Task.TaskState = Task.TaskState.created
    enum Selector {
        case service
        case workers
        case location
        case pictures
    }
    
    // for UI:
    var locationSelector: LabelRowFormer<FormLabelCell>?
    var pictureSelector: LabelRowFormer<FormLabelCell>?
    var workerSelector: LabelRowFormer<FormLabelCell>?
    var serviceSelector: LabelRowFormer<FormLabelCell>?
    var dueDatePicker: InlineDatePickerRowFormer<FormInlineDatePickerCell>?

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
    
    // MARK: onDonePressed
    @objc func onDonePressed() {
        // verify input
        guard verifyInput() else {return}
        // save edited task
        let spinner = AutoActivityIndicator(self.view, style: .gray)
        spinner.start()
        saveTask()
        spinner.stop()
        // pop current view controller
        navigationController?.popViewController(animated: true)
    }
    
    func verifyInput() -> Bool {
        // title
        if taskTitle.isEmpty {
            print("taskTitle.isEmpty")
            return false
        }
        // desc
        if desc.isEmpty {
            print("")
            return false
        }
        // service
        if service == nil {
            print("service is nil")
            return false
        }
        // workers
        if selectedWorkers.isEmpty {
            print("no workers selected")
            return false
        }
        // address
        if locationTuple == nil {
            print("no address")
            return false
        }
        // images (optional)
        // due date
        if dueDate == nil {
            print("no date")
            return false
        }
        
        return true
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
        serviceSelector = createMenu("💁 Select Service", Static.none_selected) { [weak self] in
            // perform segue here:
            self?.performSegue(withIdentifier: Static.segue_openServicePicker, sender: self)
            } as? LabelRowFormer<FormLabelCell>
        
        // MARK: Pickup Designated Workers: Multi Selection
        workerSelector = createMenu("👷 Designate Workers", Static.none_selected) { [weak self] in
            // perform segue here:
            self?.performSegue(withIdentifier: Static.segue_openWorkerPicker, sender: self)
            } as? LabelRowFormer<FormLabelCell>
        // MARK: Select Due Date of Task
        dueDatePicker = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "📆 Select Due Date"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFont(ofSize: 14)
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.onDateChanged({
                self.dueDate = $0
            }).displayTextFromDate(String.mediumDateNoTime)
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
        let sectionDatePicker = SectionFormer(rowFormer: dueDatePicker!)
        former.append(sectionFormer: sectionBasic, sectionSelectors, sectionLocationSelector, sectionUploadPicture, sectionDatePicker)
    }
    
    func saveTask() {
        if currentTask == nil {
            currentTask = Task()
            DatabaseService.shared.addTask(add: self.currentTask!, self.taskTitle, self.desc, service: self.service!, workers: self.selectedWorkers, dueData: self.dueDate!, locationTuple: self.locationTuple!, images: self.images, taskState: self.taskState, update: false)
        } else {
            DatabaseService.shared.addTask(add: self.currentTask!, self.taskTitle, self.desc, service: self.service!, workers: self.selectedWorkers, dueData: self.dueDate!, locationTuple: self.locationTuple!, images: self.images, taskState: self.taskState, update: true)
        }
    }
}

// MARK: - prepare info for segues, ui update
extension TaskEditorViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Static.segue_openWorkerPicker:
            let workerPicker = segue.destination as! WorkerPickerViewController
            workerPicker.selectedWorkers = self.selectedWorkers
            workerPicker.workerPickerDelegate = self
        case Static.segue_openServicePicker:
            let servicePicker = segue.destination as! ServicePickerViewController
            servicePicker.service = self.service
            servicePicker.servicePickerDelegate = self
            break
        case Static.segue_openLocationSelector:
            let locationSelector = segue.destination as! LocationSelectViewController
            locationSelector.locationTuple = locationTuple
            // set delegate
            locationSelector.delegate = self
        case Static.segue_openPicturePicker:
            let picPicker = segue.destination as! PicPickerViewController
            // assign images
            picPicker.images = self.images
            // set delegate
            picPicker.delegate = self
        default:
            break
        }
    }
    
    // update selector subtext
    private func updateSelectorSubText(on selector: Selector, _ selection: Any?) {
        switch selector {
        case .service:
            if let subText = selection as? String {
                serviceSelector?.subText = subText
                serviceSelector?.update()
            }
            
        case .workers:
            if let count = selection as? Int {
                let subText = String(format: count > 1 ? "%d workers" : "%d worker", count)
                workerSelector?.subText = subText
                workerSelector?.update()
            }
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
}

// MARK: - LocationSelectorDelegate, PicturePickerDelegate
extension TaskEditorViewController: LocationSelectorDelegate, PicturePickerDelegate,
WorkerPickerDelegate, ServicePickerDelegate {
    
    // LocationSelectorDelegate
    func onLocationReady(location: (address: String, latitude: Double, longitude: Double)) {
        // update local property: locationTuple
        locationTuple = location
        // update location selector menu
        updateSelectorSubText(on: .location, location.address)
    }
    
    // PicturePickerDelegate
    func onPictureSelectionFinished(images: [UIImage]) {
        // collect images to inner property.
        self.images = images
        // update subtitle for selector menu
        let count = images.count
        
        updateSelectorSubText(on: .pictures, count)
    }
    
    // WorkerPickerDelegate
    func selectionDidFinish(selectedWorkers: [Worker]) {
        // receive selected result
        self.selectedWorkers = selectedWorkers
        // update ui
        updateSelectorSubText(on: .workers, selectedWorkers.count)
    }
    
    // ServicePickerDelegate
    func selectionDidFinish(service: Service) {
        self.service = service
        updateSelectorSubText(on: .service, service.serviceTitle)
    }
}
