//
//  String+Regex.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/24.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import Foundation

extension String {
    
    /**
    正規表現に一致するかどうかを判定
    
    :param: pattern 正規表現
    
    :returns: bool
    */
    func hasMatch(pattern: String) -> Bool {
        let options: NSRegularExpressionOptions = NSRegularExpressionOptions.DotMatchesLineSeparators
        
        let regex: NSRegularExpression? = try! NSRegularExpression(pattern:pattern, options: options)
        
        var matches = 0
        if let regex: NSRegularExpression = regex {
            matches = regex.numberOfMatchesInString(self,
                options: NSMatchingOptions.ReportProgress,
                range: NSMakeRange(0, characters.count))
        }
        
        return matches > 0
    }
}