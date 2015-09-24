//
//  ViewController.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/19.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit
import BABFrameObservingInputAccessoryView

class TopController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var toolbarContainerVerticalSpacingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
        cf. https://github.com/brynbodayle/BABFrameObservingInputAccessoryView
        */
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        let inputView: BABFrameObservingInputAccessoryView = BABFrameObservingInputAccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: 44.0))
        inputView.userInteractionEnabled = false
        self.textField.inputAccessoryView = inputView
        
        inputView.keyboardFrameChangedBlock = { [unowned self] (keyboardVisible: Bool, keyboardFrame: CGRect) in
            let value: CGFloat = CGRectGetHeight(self.view.frame) - CGRectGetMinY(keyboardFrame)
            self.toolbarContainerVerticalSpacingConstraint.constant = (0 < value) ? value : 0;
            self.view.layoutIfNeeded();
        }
    }
    
    
    // MARK: - Action
    
    @IBAction func onSearchButton(sender: UIButton) {
        self.performSegueWithIdentifier("TopToBrowse", sender: nil)
    }
    
    @IBAction func onMoreButton(sender: UIButton) {
        // TODO: show information page
    }

    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DayCell = tableView.dequeueReusableCellWithIdentifier("DayCell") as! DayCell
        
        cell.titleLabel.text = "2015/01/01"
        cell.countLabel.text = "(10)"
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}

