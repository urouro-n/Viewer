//
//  FilteringURLProtocol.swift
//  Viewer
//
//  Created by Kenta Nakai on 2015/09/25.
//  Copyright (c) 2015年 UROURO. All rights reserved.
//

import Foundation

/**
 cf. http://qiita.com/shzero5/items/755fd80bc759a5460c43
 */
class FilteringURLProtocol : NSURLProtocol {
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        let host: String? = request.URL!.host
        
        if host == nil {
            return false
        }
        
        return AdBlockList.isBlack(host!)
    }
    
    override class func canonicalRequestForRequest (request: NSURLRequest) -> NSURLRequest {
        return request;
    }
    
    override func startLoading() {
        let response = NSURLResponse(URL: self.request.URL!, MIMEType: nil, expectedContentLength: 0, textEncodingName: nil)
        self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
        self.client?.URLProtocol(self, didLoadData: NSData(bytes: nil, length: 0))
        self.client?.URLProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
