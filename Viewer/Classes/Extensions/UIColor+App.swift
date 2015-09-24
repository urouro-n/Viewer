//
//  UIColor+App.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/23.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit

extension UIColor {
    
    private class func rgba(red red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha / 1.0)
    }
    
    class func appLightGrayColor() -> UIColor {
        return UIColor.rgba(red: 213.0, green: 213.0, blue: 213.0, alpha: 1.0)
    }
    
}
