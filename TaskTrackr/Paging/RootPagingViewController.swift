//
//  BasisRootViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 5/09/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit
import Parchment

protocol ManageItemDelegate {
    func addItem()
    func editingMode(editing: Bool, animate: Bool)
}

class RootPagingViewController: UIViewController, PagingViewControllerDelegate, PagingViewControllerDataSource {
    
    var pagingViewController = PagingViewController<PagingIndexItem>()
    var viewControllers:[UIViewController] = []
    var currentViewController: UIViewController?
    
    var delegate: ManageItemDelegate?
    
    /*  PagingViewControllerDataSourceDataSource
     */
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
        return PagingIndexItem(index: index, title: viewControllers[index].title!) as! T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
        return viewControllers[index]
    }
    
    
    func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
        return self.viewControllers.count
    }
    
    /* PagingViewControllerDelegate
     */
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        guard transitionSuccessful else {
            return
        }
        // update title for navigation bar
        updateNavigationBarTitle(to: destinationViewController.title!)
        // update value of currentViewController
        currentViewController = destinationViewController
        // set currentViewController as ManageItemDelegate
        delegate = currentViewController as? ManageItemDelegate
    }
    
    func updateNavigationBarTitle(to newTitle: String) {
        let newTitle = String(format: "Manage %@", newTitle)
        self.navigationController?.navigationBar.topItem?.title = newTitle
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        viewControllers = [getInstance(with: Constants.ACTION_PAGE),
                           getInstance(with: Constants.WORKER_PAGE),
                           getInstance(with: Constants.PRODUCT_PAGE),
                           getInstance(with: Constants.TOOL_PAGE),
                           getInstance(with: Constants.SITE_PAGE)]
        
        initPagingViewController()
        pagingViewController.delegate = self
        pagingViewController.dataSource = self
        
        // initially set the first view controller to be the default page
        currentViewController = viewControllers[0]
        delegate = currentViewController as? ManageItemDelegate
        
        
        setLeftBarItem()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        delegate?.addItem()
    }
    
    func initPagingViewController() {
//        pagingViewController = FixedPagingViewController(viewControllers: getViewControllers())
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
        
    func getViewControllers() -> [UIViewController] {
        
        return viewControllers
    }
    
    func setLeftBarItem() {
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    /* get instance of selected viewController
     */
    func selectedViewController(selectedPageIndex: Int) -> UIViewController? {
        
        switch selectedPageIndex {
        case 0: // Action
            return getInstance(with: Constants.ACTION_PAGE)
        case 1: // Worker
            return getInstance(with: Constants.WORKER_PAGE)
        case 2: // Product
            return getInstance(with: Constants.PRODUCT_PAGE)
        case 3: // Tool
            return getInstance(with: Constants.TOOL_PAGE)
        case 4: // Site
            return getInstance(with: Constants.SITE_PAGE)
        default:
            return nil
        }
    }
    
    /*
        Get Instance of UIViewController
     */
    func getInstance(with indentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: indentifier)
    }
    
    /**
        Whenever Edit/Done button clicked, this method is called.
     */
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        delegate?.editingMode(editing: editing, animate: animated)
    }
}
