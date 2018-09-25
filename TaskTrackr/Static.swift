//
//  Constants.swift
//  TaskTrackr
//
//  Created by Eric Ho on 4/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
import Toaster
import RealmSwift

struct Static {
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
    
    // user status: has signed in?
    static var currentUser: SyncUser?
    
    static let action_page = "ActionViewController"
    static let worker_page = "WorkerViewController"
    static let product_page = "ProductViewController"
    static let tool_page = "ToolViewController"
    static let site_page = "SiteViewController"
    static let root_page = "RootPagingViewController"
    
    static let action_segue = "OpenActionForm"
    static let worker_segue = "OpenWorkerForm"
    static let product_segue = "OpenProductForm"
    static let tool_segue = "OpenToolForm"
    static let site_segue = "OpenSiteForm"
    static let selector_segue = "OpenSelectorController"
    static let pickup_segue = "OpenPickupController"
    
    static func showToast(toastText: String) {
        Toast(text: toastText, delay: 0, duration: Delay.long).show()
    }
    
    /*
     static: Get Instance of UIViewController using storyboard identifier.
     */
    static func getInstance(with indentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: indentifier)
    }
}
