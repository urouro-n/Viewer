//
//  BrowseController.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/24.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import SVProgressHUD

class BrowseController: UIViewController, MWPhotoBrowserDelegate {
    
    @IBOutlet private weak var webView: UIWebView!
    
    var URL: NSURL = NSURL(string: "https://www.google.com")!
    
    private var photos: [MWPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "close-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "onCloseItem:")
        closeItem.tintColor = UIColor.appLightGrayColor()
        self.navigationItem.leftBarButtonItem = closeItem
        
        let shareItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "share-button"), style: .Plain, target: self, action: "onShareItem:")
        shareItem.tintColor = UIColor.appLightGrayColor()
        self.navigationItem.rightBarButtonItem = shareItem
        
        self.webView.loadRequest(NSURLRequest(URL: self.URL))
    }
    
    
    // MARK: - Action
    
    func onCloseItem(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onShareItem(sender: UIBarButtonItem) {
        // TODO: show UIActivityViewController
    }
    
    @IBAction func onImageGetButton(sender: UIButton) {
        let html: String? = self.webView!.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        var url: String? = self.webView!.stringByEvaluatingJavaScriptFromString("location.protocol")
        url = (url != nil) ? url! + "//" : nil
        url = (url != nil) ? url! + self.webView!.stringByEvaluatingJavaScriptFromString("location.host")! : nil
        
        if html == nil || url == nil {
            print("HTML body or url nil")
            return
        }
        
        let result: [String] = HTMLParser.parseImageURL(html!)
        print("result=\(result)")
        
        self.openImageViewer(result, currentURL: url)
    }
    
    /**
    画像ビューワを表示
    
    :param: URLs 画像 URL
    */
    private func openImageViewer(URLs: [String], currentURL: String?) {
        SVProgressHUD.showWithStatus(String(URLs.count) + "枚の画像を読込中...")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.photos.removeAll(keepCapacity: false)
            
            for var i: Int = 0; i < URLs.count; i++ {
                var URLString: String = URLs[i]
                
                if URLString.hasMatch("^//") {
                    // パスが `//` で指定されている場合、 `http://` をつける
                    URLString = "http:" + URLString
                } else if !URLString.hasMatch("^http://") && !URLString.hasMatch("^https://") && currentURL != nil {
                    // パスに http:// or https:// が含まれない場合、ホスト名をつける
                    URLString = currentURL! + URLString
                }
                
                let URL: NSURL = NSURL(string: URLString)!
                let data: NSData? = NSData(contentsOfURL: URL)
                
                if data == nil {
                    print("URLString=\(URLString), nil data")
                    continue
                }
                
                let image: UIImage? = UIImage(data: data!)
                
                if image == nil {
                    print("URLString=\(URLString), nil image")
                    continue
                }
                
                // 1x1 の画像は対象から外す
                if image!.size.width == 1 && image!.size.height == 1 {
                    print("URLString=\(URLString), 1x1 image")
                    continue
                }
                
                print("URL=\(URLString)")
                
                let photo: MWPhoto = MWPhoto(image: image)
                photo.caption = URL.lastPathComponent! + "\n" + "(1,280 x 960)"
                self.photos.append(photo)
            }
            
            print("photos=\(self.photos)")
            
            dispatch_sync(dispatch_get_main_queue(), {
                
                SVProgressHUD.dismiss()
                
                if self.photos.count == 0 {
                    let alert: UIAlertController = UIAlertController(title: nil,
                        message: "画像が取得できませんでした",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                let iconImage: UIImage = UIImage(named: "download-button")!.scaleToFitSize(CGSizeMake(28.0, 28.0))
                let browser: MWPhotoBrowser = MWPhotoBrowser(delegate: self)
                browser.displayNavArrows = true
                browser.displayActionButton = true
                // browser.actionButton = UIBarButtonItem(image: iconImage, style: .Plain, target: nil, action: nil)
                self.navigationController?.pushViewController(browser, animated: true)
            })
        })
    }
    
    
    // MARK: - MWPhotoBrowserDelegate
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if Int(index) < self.photos.count {
            return self.photos[Int(index)]
        }
        
        return nil
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, actionButtonPressedForPhotoAtIndex index: UInt) {
        /**
        画像を Documents に保存
        */
//        let photo: MWPhoto = self.photos[Int(index)]
//        let image: UIImage = photo.image
//        let imageData: NSData = UIImagePNGRepresentation(image)!
//        
//        print("save / image=\(image)")
//        
//        let imageName: NSString = photo.caption
//        let date: NSDate = NSDate()
//        let folderName: NSString = NSString(format: "%04d%02d%02d", date.year, date.month, date.day)
//        let folderPath: NSString = self.documentsDirectory + "/" + (folderName as String)
//        print("folderPath=\(folderPath)")
//        
//        try! NSFileManager.defaultManager().createDirectoryAtPath(folderPath as String, withIntermediateDirectories: false, attributes: nil)
//        
//        let filePath: NSString =  folderPath.stringByAppendingPathComponent(imageName as String)
//        print("filePath=\(filePath)")
//
//        do {
//            try imageData.writeToFile(filePath as String, options: NSDataWritingOptions.AtomicWrite)
//        } catch  {
//            print("writeToFile Error / error=\(error)")
//            Notificator.failure("保存に失敗しました")
//            return
//        }
//        
//        Notificator.success("保存しました")
    }
    
}
