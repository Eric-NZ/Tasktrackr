//
//  Constants.swift
//  TaskTrackr
//
//  Created by Eric Ho on 4/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation

struct Constants {
    // **** Realm Cloud Users:
    // **** Replace MY_INSTANCE_ADDRESS with the hostname of your cloud instance
    // **** e.g., "mycoolapp.us1.cloud.realm.io"
    // ****
    // ****
    // **** ROS On-Premises Users
    // **** Replace the AUTH_URL string with the fully qualified versions of
    // **** address of your ROS server, e.g.: "http://127.0.0.1:9080"
    
    static let MY_INSTANCE_ADDRESS = "task-tracker.us1a.cloud.realm.io" // <- update this
    
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/TaskTrackr")!
    
    
    static let ACTION_PAGE = "ActionViewController"
    static let WORKER_PAGE = "WorkerViewController"
    static let PRODUCT_PAGE = "ProductViewController"
    static let TOOL_PAGE = "ToolViewController"
    static let SITE_PAGE = "SiteViewController"
    static let ROOT_PAGE = "RootPagingViewController"
    static let ITEM_FORM = "ItemFormController"
    
    static let PRODUCT_MODELS = "ProductModelForm"
    
    static let ACTION_SEGUE = "OpenActionForm"
    static let WORKER_SEGUE = "OpenWorkerForm"
    static let PRODUCT_SEGUE = "OpenProductForm"
    static let TOOL_SEGUE = "OpenToolForm"
    static let SITE_SEGUE = "OpenSiteForm"
    static let SELECTION_SEGUE = "ShowSelectionController"
}
