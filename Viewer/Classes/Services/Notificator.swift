//
//  Notificator.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/24.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import Foundation

class Notificator : NSObject {
    
    enum Color {
        case Success
        case Failure
        
        func color() -> UIColor {
            switch self {
            case .Success:
                return UIColor(red:0.18, green:0.8, blue:0.44, alpha:1)
            case .Failure:
                return UIColor(red:0.91, green:0.3, blue:0.24, alpha:1)
            }
        }
    }
    
    class var font: UIFont {
        return UIFont(name: "HiraKakuProN-W6", size: 12.0)!
    }
    
    class func success(message: String) {
        var options = Notificator.defaultOptions()
        options[kCRToastTextKey] = message
        options[kCRToastBackgroundColorKey] = Color.Success.color()
        
        CRToastManager.showNotificationWithOptions(options, completionBlock: {})
    }
    
    class func failure(message: String) {
        var options = Notificator.defaultOptions()
        options[kCRToastTextKey] = message
        options[kCRToastBackgroundColorKey] = Color.Failure.color()
        
        CRToastManager.showNotificationWithOptions(options, completionBlock: {})
    }
    
    class func defaultOptions() -> [NSObject: AnyObject]! {
        return [
            kCRToastFontKey: Notificator.font,
            // kCRToastNotificationTypeKey: 1,
        ]
    }
}
