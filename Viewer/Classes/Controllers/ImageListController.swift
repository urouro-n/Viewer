//
//  ImageListController.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/25.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit
import MWPhotoBrowser

class ImageListController: UICollectionViewController, MWPhotoBrowserDelegate {
    
    var directory: String?
    var images: [MWPhoto] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.reloadData()
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ImageListCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("ImageListCell", forIndexPath: indexPath) as! ImageListCell
        
        let image: MWPhoto = self.images[indexPath.item]
        cell.imageView.image = image.image
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.openPhotoBrowser(indexPath.item)
    }
    
    
    // MARK: - MWPhotoBrowserDelegate
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.images.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if Int(index) < self.images.count {
            return self.images[Int(index)]
        }
        
        return nil
    }
    
    
    // MARK: - Private Methods
    
    private func reloadData() {
        if self.directory == nil {
            log.error("directory is nil")
            return
        }
        
        let items: [AnyObject]? = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(self.directory!)
        
        if items == nil {
            log.error("items=\(items)")
            return
        }
        
        self.images.removeAll(keepCapacity: false)
        
        for item: String in items as! [String] {
            let fileURL: NSURL? = NSURL(fileURLWithPath: (self.directory! as NSString).stringByAppendingPathComponent(item))
            
            if let url = fileURL {
                let image: UIImage = UIImage(contentsOfFile: url.path!)!
                let photo: MWPhoto = MWPhoto(image: image)
                self.images.append(photo)
            }
        }
        
        log.debug("images=\(self.images)")
        
        self.collectionView?.reloadData()
    }
    
    private func openPhotoBrowser(index: Int) {
        let browser: MWPhotoBrowser = MWPhotoBrowser(delegate: self)
        browser.displayNavArrows = true
        browser.setCurrentPhotoIndex(UInt(index))
        
        self.navigationController?.pushViewController(browser, animated: true)
    }
    
}
