//
//  LocationSelectViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 12/10/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSelectorDelegate {
    func onLocationReady(location: (address: String, latitude: Double, longitude: Double))
}

class LocationSelectViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var searchResultTable: SearchResultTable?
    var searchResult: [MKMapItem] = []
    var currentMapItem: MKMapItem?
    var delegate: LocationSelectorDelegate?
    // using this Tuple to communicate with other controllers
    var locationTuple: (address: String, latitude: Double, longitude: Double)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init searchResultTable and delegate
        searchResultTable = storyboard?.instantiateViewController(withIdentifier: "SearchResultTable") as? SearchResultTable
        searchResultTable?.delegate = self
        // create a search controller
        setupNavigationItem()
        
        // init region
        initRegion(rangeSpan: Static.regionSpan)
        
        // set camera to original location
        if let place = locationTuple {
            // restore map item
            wrapMapItem()
            // zoom to location
            zoomToLocation(location: place)
            // update search bar text
            updateNavigationItem(currentMapItem)
        } else {
            print("location tuple is nil")
        }
        
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
        if let annotation = mapView.annotations.first {
            // update text on search bar
            navigationItem.searchController?.searchBar.text = annotation.title!
            // add right button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(onDoneButton))
        } else {
            // delete right button
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    // restore mapItem using Geo data
    func wrapMapItem() {
        if let location = locationTuple {
            let coodinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            let placemark = MKPlacemark(coordinate: coodinate2D)
            
            let mapItem = MKMapItem(placemark: placemark)
            // set current map item
            currentMapItem = mapItem
        }
    }
    
    func initRegion(rangeSpan: (latitudeDelta: Double, longitudeDelta: Double)) {
        // 2D coordinate: 
        let coordinate2d = CLLocationCoordinate2DMake(Static.userLocationDegree.0, Static.userLocationDegree.1)
        
        let region = MKCoordinateRegion(center: coordinate2d, latitudinalMeters: rangeSpan.latitudeDelta, longitudinalMeters: rangeSpan.longitudeDelta)
        mapView.region = region
    }
    
    @objc func onCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onDoneButton() {
        
        if (locationTuple != nil), delegate != nil {
            // deliver tuple value
            delegate?.onLocationReady(location: locationTuple!)
        }
        // dismiss current view controller
        navigationController?.popViewController(animated: true)
    }
    
}

extension LocationSelectViewController: SearchResultTableDelegate {

    // MARK: - UISearchBarDelegate
    
    // text in search bar changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if text deleted
        if searchText.isEmpty {
            // remove existing annotations
            let annotations = mapView.annotations
            mapView.removeAnnotations(annotations)
            // update search text
            updateNavigationItem()
        }
        // if input new key word
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
        let place = (address: searchResult[index].placemark.title!,
                     latitude: searchResult[index].placemark.coordinate.latitude,
                     longitude: searchResult[index].placemark.coordinate.longitude)
        zoomToLocation(location: place)
        // update location tuple
        locationTuple = place
        // update navigationBar
        updateNavigationItem(item)
        // set selectedMapItem
        currentMapItem = item
    }
    
    // zoom to location with a pin
    func zoomToLocation(location: (address: String, latitude: Double, longitude: Double)) {
        let coodinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        // remove existing annotations
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        // update camera
        let camera = MKMapCamera(lookingAtCenter: coodinate2D, fromDistance: 300.00, pitch: 60.00, heading: 0)
        mapView.setCamera(camera, animated: true)
        // add a pin(annotation)
        let pin = MKPointAnnotation()
        pin.coordinate = coodinate2D
        pin.title = location.address
        mapView.addAnnotation(pin)
    }
}
