//
//  UIViewController+Documents.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/24.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit

extension UIViewController {
    var documentsDirectory: String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)[0] 
    }
}