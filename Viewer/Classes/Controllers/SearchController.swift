//
//  SearchController.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/23.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var toolbarContainerVerticalSpacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "close-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "onCloseItem:")
        closeItem.tintColor = UIColor.appLightGrayColor()
        navigationItem.leftBarButtonItem = closeItem
    }
    
    
    // MARK: - Action
    
    func onCloseItem(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: UIButton) {
        performSegueWithIdentifier("SearchToBrowse", sender: nil)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: WebListCell = tableView.dequeueReusableCellWithIdentifier("WebListCell") as! WebListCell
        
        cell.titleLabel.text = "www.example.com"
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}
