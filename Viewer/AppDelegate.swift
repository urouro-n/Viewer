//
//  AppDelegate.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/19.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit
import XCGLogger

let log = XCGLogger.defaultInstance()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // XCGLogger Setup
        log.setup(XCGLogger.LogLevel.Debug,
            showThreadName: false,
            showLogLevel: true,
            showFileNames: true,
            showLineNumbers: true,
            writeToFile: nil,
            fileLogLevel: nil)
        
        return true
    }

}

