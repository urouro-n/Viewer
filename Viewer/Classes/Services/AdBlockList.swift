//
//  AdBlockList.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/25.
//  Copyright (c) 2015年 UROURO. All rights reserved.
//

import Foundation

class AdBlockList : NSObject {
    class func blackList () -> [String] {
//        return [
//            ".*\\.example\\.com"
//        ]
        
        guard let path = NSBundle.mainBundle().pathForResource("blackList", ofType: "txt") else {
            return []
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            return content.componentsSeparatedByString("\n")
        } catch _ as NSError {
            return []
        }
    }
    
    class func isBlack(URLString: String) -> Bool {
        let list: [String] = AdBlockList.blackList()
        //log.debug("list=\(list)")
        
        for blackURLString: String in list {
            if blackURLString.characters.count > 0 && URLString.hasMatch(blackURLString) {
                return true
            }
        }
        
        log.debug("white URL: \(URLString)")
        
        return false
    }
}