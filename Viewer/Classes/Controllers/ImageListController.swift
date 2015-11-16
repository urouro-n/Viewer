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
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        reloadData()
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ImageListCell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageListCell", forIndexPath: indexPath) as! ImageListCell
        
        let image: MWPhoto = images[indexPath.item]
        cell.imageView.image = image.image
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        openPhotoBrowser(indexPath.item)
    }
    
    
    // MARK: - MWPhotoBrowserDelegate
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(images.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if Int(index) < images.count {
            return images[Int(index)]
        }
        
        return nil
    }
    
    
    // MARK: - Private Methods
    
    private func reloadData() {
        if directory == nil {
            log.error("directory is nil")
            return
        }
        
        let items: [AnyObject]? = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(directory!)
        
        if items == nil {
            log.error("items=\(items)")
            return
        }
        
        images.removeAll(keepCapacity: false)
        
        for item: String in items as! [String] {
            let fileURL: NSURL? = NSURL(fileURLWithPath: (directory! as NSString).stringByAppendingPathComponent(item))
            
            if let url = fileURL {
                let image: UIImage = UIImage(contentsOfFile: url.path!)!
                let photo: MWPhoto = MWPhoto(image: image)
                images.append(photo)
            }
        }
        
        log.debug("images=\(images)")
        
        collectionView?.reloadData()
    }
    
    private func openPhotoBrowser(index: Int) {
        let browser: MWPhotoBrowser = MWPhotoBrowser(delegate: self)
        browser.displayNavArrows = true
        browser.setCurrentPhotoIndex(UInt(index))
        
        navigationController?.pushViewController(browser, animated: true)
    }
    
}
