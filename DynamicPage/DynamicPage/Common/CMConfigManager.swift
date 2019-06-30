//
//  CMConfigManager.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/6/5.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

class CMConfingManager: NSObject {
    static let shared = CMConfingManager()
    
    var isFirstConfig:Bool {
        get {
            return isNeedConfing
        }
    }
    
    fileprivate var isNeedConfing:Bool = true
    
    
    public func setConfigManager(isConfig:Bool) {
        if isConfig {
            isNeedConfing = false
        }
    }
    
}
