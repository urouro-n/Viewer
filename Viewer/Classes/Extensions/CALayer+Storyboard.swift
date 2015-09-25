//
//  CALayer+Storyboard.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/25.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import UIKit

extension CALayer {
    
    func setBorderColorFromUIColor(color: UIColor) {
        self.borderColor = color.CGColor
    }
    
}
