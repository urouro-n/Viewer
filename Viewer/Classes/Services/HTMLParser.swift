//
//  HTMLParser.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/03/28.
//  Copyright (c) 2015年 UROURO. All rights reserved.
//

import Foundation

class HTMLParser : NSObject {
    
    class func parseImageURL(html: NSString) -> [String] {
        let pattern: NSString = "(<img.*?src=\\\")(.*?)(\\\".*?>)"
        let regex: NSRegularExpression? = try! NSRegularExpression(pattern: pattern as String, options: NSRegularExpressionOptions.CaseInsensitive)
        
        if regex == nil {
            return []
        }
        
        let matches: NSArray = regex!.matchesInString(html as String, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, html.length))
        
        var results: [String] = []
        for match in matches {
            let url: String = html.substringWithRange(match.rangeAtIndex(2))
            
            // 同じ URL は含まない
            if !results.contains(url) {
                results.append(url)
            }
        }
        
        return results
    }
}