//
//  LocationSelectViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 12/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import MapKit

class LocationSelectViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var searchResultTable: SearchResultTable?
    var searchResult: [MKMapItem] = []
    var selectedMapItem: MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init searchResultTable and delegate
        searchResultTable = storyboard?.instantiateViewController(withIdentifier: "SearchResultTable") as? SearchResultTable
        searchResultTable?.delegate = self
        // create a search controller
        setupNavigationItem()
        // restore map item
        restoreMapItem()
        // init camera using selectedMapItem
        initCamera()
        
    }
    
    func setupNavigationItem() {
        if  let searchResult = searchResultTable {
            let searchController = UISearchController(searchResultsController: searchResult)
            searchController.hidesNavigationBarDuringPresentation = false
            // NOTE: without setting definesPresentationContext to true, the search bar disappears when text changed
            definesPresentationContext = true
            let searchBar = searchController.searchBar
            searchBar.sizeToFit()
            searchBar.delegate = self
            searchBar.placeholder = "Search for an address"
            
            // add search controller
            navigationItem.searchController = searchController
        }
    }
    
    // update navigation item
    func updateNavigationItem(_ selectedItem: MKMapItem? = nil) {
        if let item = selectedItem {
            // update text on search bar
            navigationItem.searchController?.searchBar.text = item.placemark.title
            // add right button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(onDoneButton))
        } else {
            // delete right button
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    // restore mapItem using Geo data
    func restoreMapItem() {
        
    }
    
    func initCamera() {
        if let mapItem = selectedMapItem {
            // zoom to selected item
            zoomToSelectedPlace(mapItem: mapItem)
        } else {
            // init region
            initRegion(rangeSpan: MKCoordinateSpan(latitudeDelta: Static.regionSpan.0, longitudeDelta: Static.regionSpan.1))
        }
    }
    
    func initRegion(rangeSpan: MKCoordinateSpan) {
        // 2D coordinate: 
        let coordinate2d = CLLocationCoordinate2DMake(Static.userLocationDegree.0, Static.userLocationDegree.1)
        
        let region = MKCoordinateRegion(center: coordinate2d, latitudinalMeters: rangeSpan.latitudeDelta, longitudinalMeters: rangeSpan.longitudeDelta)
        mapView.region = region
    }
    
    @objc func onCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onDoneButton() {
        // save map item info
        if let item = selectedMapItem {
            print(item.placemark.title!)
        }
    }
    
}

extension LocationSelectViewController: SearchResultTableDelegate {

    // MARK: - UISearchBarDelegate
    
    // text in search bar changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if text deleted
        if searchText.isEmpty {
            updateNavigationItem()
            // clear annotations
            // remove existing annotations
            let annotations = mapView.annotations
            mapView.removeAnnotations(annotations)
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                if let mapItems = response?.mapItems {
                    // update result table
                    self.reloadResultTable(mapItems: mapItems)
                    // update self.searchResult
                    self.searchResult = mapItems
                }
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func reloadResultTable(mapItems: [MKMapItem]) {
        var items: [String] = []
        for item in mapItems {
            items.append(item.placemark.title!)
        }
        
        searchResultTable?.loadMatchingItems(items: items)
    }
    
    // MARK: - SearchResultTableDelegate
    func didResultItemSelected(index: Int) {
        // get selected MKMapItem
        let item = searchResult[index]
        // dismiss search result table view controller
        searchResultTable?.dismiss(animated: true, completion: nil)
        // zoom to selected item
        zoomToSelectedPlace(mapItem: item)
        // update navigationBar
        updateNavigationItem(item)
        // set selectedMapItem
        selectedMapItem = item
    }
    
    // zoom to place with a pin
    func zoomToSelectedPlace(mapItem: MKMapItem) {
        // remove existing annotations
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        // update camera
        let camera = MKMapCamera(lookingAtCenter: mapItem.placemark.coordinate, fromDistance: 500.00, pitch: 60.00, heading: 0)
        mapView.setCamera(camera, animated: true)
        // add a pin(annotation)
        let pin = MKPointAnnotation()
        pin.coordinate = mapItem.placemark.coordinate
        pin.title = mapItem.placemark.title
        mapView.addAnnotation(pin)
    }
}
