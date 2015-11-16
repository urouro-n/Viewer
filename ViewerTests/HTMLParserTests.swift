//
//  HTMLParserTests.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/26.
//  Copyright © 2015年 UROURO. All rights reserved.
//

import Foundation
import XCTest

class HTMLParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testImageURL() {
        let results: [String] = HTMLParser.parseImageURL(html: "<html lang=\"ja\"><body><img src=\"http://example.com/test.jpg\"><hr /><img alt=\"test\" src=\"http://example.com/test2.png\"></body></html>")
        
        XCTAssertEqual(2, results.count)
        XCTAssertEqual("http://example.com/test.jpg", results[0])
        XCTAssertEqual("http://example.com/test2.png", results[1])
    }
    
    func testImageURLInATag() {
        var html: String = ""
        html += "<html lang=\"ja\">"
        html += "<body>"
        html += "<a href=\"http://example.com/test-large.jpg\"><img src=\"http://example.com/test.jpg\"></a>"
        html += "<hr />"
        html += "<img alt=\"test\" src=\"http://example.com/test2.png\">"
        html += "</body></html>"
        
        let results: [String] = HTMLParser.parseImageURL(html: html)
        
        XCTAssertEqual(2, results.count)
        XCTAssertEqual("http://example.com/test-large.jpg", results[0])
        XCTAssertEqual("http://example.com/test2.png", results[1])
    }
    
}
