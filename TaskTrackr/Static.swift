//
//  Constants.swift
//  TaskTrackr
//
//  Created by Eric Ho on 4/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import Foundation
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
    
    static let MY_INSTANCE_ADDRESS = "allcompleted.us1a.cloud.realm.io" // <- update this
    
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/TaskTracker")!
    
    static let permissionController = "PermissionController"
    
    static let page_service = "ServiceViewController"
    static let page_worker = "WorkerViewController"
    static let page_product = "ProductViewController"
    static let page_tool = "ToolViewController"
    static let pageRouter = "RootPagingViewController"
    
    static let segue_openServiceForm = "OpenServiceForm"
    static let segue_openWorkerForm = "OpenWorkerForm"
    static let segue_openProductForm = "OpenProductForm"
    static let segue_openToolForm = "OpenToolForm"
    static let segue_openProductSelector = "OpenProductPicker"
    static let segue_openToolSelector = "OpenToolPicker"
    static let segue_openTaskEditor = "OpenTaskEditor"
    static let segue_openWorkerPicker = "OpenWorkerPicker"
    static let segue_openServicePicker = "OpenServicePicker"
    static let segue_openLocationSelector = "OpenLocationSelector"
    static let segue_openPicturePicker = "OpenPicturePicker"
    
    static let none_selected = "None Selected"
    static let not_set = "Not Set"
    
    enum Emojis: String {
        case service = "💁"
        case worder = "👷"
        case product = "🚿"
        case tool = "🔨"
        case site = "📍"
    }
    
    // Users' location latitude and longtitude
    static let userLocationDegree = (-36.848461, 174.763336)    // Auckland
    // 400KM
    static let regionSpan = (400000.00, 400000.00)
    
    /*
     static: Get Instance of UIViewController using storyboard identifier.
     */
    static func getInstance(with indentifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: indentifier)
    }
    
    // trim String to designate length with '...'
    static func trimString(for string: String? = nil, to length: Int, _ withDots: Bool? = true) -> String? {
        if var string = string {
            let index = string.index(string.startIndex, offsetBy: length)
            string = String(string[..<index])
            string = String(format: withDots! ? "%@...": "%@", string)
            return string
        } else {
            return nil
        }
    }
    
    // get a complementary color to this color
    static func getComplementaryForColor(color: UIColor) -> UIColor {
        
        let ciColor = CIColor(color: color)
        
        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }

}

// Device Info
struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}

