//
//  HTMLParser.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/03/28.
//  Copyright (c) 2015年 UROURO. All rights reserved.
//

import Foundation

class HTMLParser : NSObject {
    
    class func parseImageURL(html html: NSString) -> [String] {
        let parsedURL: [String] = HTMLParser.parseImgTag(html: html)
        return HTMLParser.parseAAndImgTag(html: html, parsedImageURLs: parsedURL)
    }
    
    private class func parseImgTag(html html: NSString) -> [String] {
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
    
    class func parseAAndImgTag(html html: NSString, parsedImageURLs: [String]) -> [String] {
        let pattern: NSString = "(<a.*?href=\\\")(.*?)(\\\".*?><img.*?src=\\\")(.*?)(\\\".*?></a>)"
        let regex: NSRegularExpression? = try! NSRegularExpression(pattern: pattern as String, options: NSRegularExpressionOptions.CaseInsensitive)
        
        if regex == nil {
            return []
        }
        
        let matches: [NSTextCheckingResult] = regex!.matchesInString(html as String, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, html.length))
        
        var results: [String] = []
        for match in matches {
            let linkedImgUrl: String = html.substringWithRange(match.rangeAtIndex(2))
            let imgUrl: String = html.substringWithRange(match.rangeAtIndex(4))

            for parsedImageURL in parsedImageURLs {
                if parsedImageURL == linkedImgUrl {
                    // 同じURLの場合
                    results.append(parsedImageURL)
                } else if parsedImageURL == imgUrl {
                    // 同じURLでAタグがあったものの場合、AタグのURLに入れ替える
                    results.append(linkedImgUrl)
                } else {
                    results.append(linkedImgUrl)
                }
            }
        }
        
        return results
    }
}