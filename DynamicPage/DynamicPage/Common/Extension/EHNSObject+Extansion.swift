//
//  EHNSObject+Extansion.swift
//  EHViewer
//
//  Created by 刘文志 on 2019/1/27.
//  Copyright © 2019 WangleBuWang. All rights reserved.
//

import UIKit

extension NSObject {
    
    /// 类名属性
    var ClassName: String {
        get {
            let name = type(of: self).description()
            if name.contains(".") {
                return name.components(separatedBy: ".")[1]
            } else {
                return name
            }
        }
    }
    
    /// 获取类名
    class func className() -> String {
        let name = String(describing: self)
        if name.contains(".") {
            return name.components(separatedBy: ".")[1]
        } else {
            return name
        }        
    }
}


