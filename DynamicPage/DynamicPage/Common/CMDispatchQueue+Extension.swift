//
//  CMDispatchQueue+Extension.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/16.
//  Copyright © 2019 YCM. All rights reserved.
//


import Foundation

public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
