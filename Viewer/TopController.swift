//
//  ViewController.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/19.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit
import BABFrameObservingInputAccessoryView

class TopController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var toolbarContainerVerticalSpacingConstraint: NSLayoutConstraint!
    
    private var directories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
        cf. https://github.com/brynbodayle/BABFrameObservingInputAccessoryView
        */
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        let inputView: BABFrameObservingInputAccessoryView = BABFrameObservingInputAccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: 44.0))
        inputView.userInteractionEnabled = false
        textField.inputAccessoryView = inputView
        
        inputView.keyboardFrameChangedBlock = { [unowned self] (keyboardVisible: Bool, keyboardFrame: CGRect) in
            let value: CGFloat = CGRectGetHeight(self.view.frame) - CGRectGetMinY(keyboardFrame)
            self.toolbarContainerVerticalSpacingConstraint.constant = (0 < value) ? value : 0;
            self.view.layoutIfNeeded();
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        reloadData()
    }
    
    
    // MARK: - Action
    
    @IBAction func onSearchButton(sender: UIButton) {
        guard let text = textField.text else {
            return
        }
        guard text.characters.count > 0 else {
            return
        }
        
        view.endEditing(true)
        performSegueWithIdentifier("TopToBrowse", sender: text)
    }
    
    @IBAction func onMoreButton(sender: UIButton) {
        // TODO: show information page
    }
    
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TopToImageList" {
            let controller: ImageListController = segue.destinationViewController as! ImageListController
            let directory: String = sender as! String
            controller.directory = (documentsDirectory as NSString).stringByAppendingPathComponent(directory)
        } else if segue.identifier == "TopToBrowse" {
            if let urlString = sender as? String {
                var url: String = urlString
                if !url.hasMatch("^http://") && !url.hasMatch("^https://") {
                    url = "http://" + url
                }
                log.debug("url=\(url)")
                
                let nav: UINavigationController = segue.destinationViewController as! UINavigationController
                let controller: BrowseController = nav.topViewController as! BrowseController
                controller.URL = NSURL(string: url)
            }
        }
    }

    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DayCell = tableView.dequeueReusableCellWithIdentifier("DayCell") as! DayCell
        
        cell.titleLabel.text = directories[indexPath.row]
        
        // TODO: show number of images
        cell.countLabel.text = ""
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let directory: String = directories[indexPath.row]
        
        self.performSegueWithIdentifier("TopToImageList", sender: directory)
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        guard text.characters.count > 0 else {
            return true
        }
        
        view.endEditing(true)
        performSegueWithIdentifier("TopToBrowse", sender: text)
        
        return true
    }
    
    
    // MARK: - Private
    
    private func reloadData() {
        /**
        * Documents 下のディレクトリの一覧を取得する
        */
        directories.removeAll(keepCapacity: false)
        
        let items: [AnyObject]? = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsDirectory)
        
        if items != nil {
            for item: String in items as! [String] {
                let path: String = (documentsDirectory as NSString).stringByAppendingPathComponent(item)
                var isDirectory: ObjCBool = false
                NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory)
                
                if isDirectory {
                    directories.append(item)
                }
            }
        }
        
        log.debug("directories=\(directories)")
        
        tableView.reloadData()
    }
    
}

