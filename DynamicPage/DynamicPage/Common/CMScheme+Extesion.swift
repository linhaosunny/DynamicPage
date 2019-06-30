//
//  CMScheme+Extesion.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/6/5.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

class CMScheme {
    
    /// 获取自己的scheme
    ///
    /// - Returns: <#return value description#>
    class func getScheme() -> String? {
        
        let infoDic = Bundle.main.infoDictionary
        guard let bundleUrlTypes = infoDic?["CFBundleURLTypes"] as? [[String : Any]] else {
            return nil
        }
        var scheme: String?
        
        for urlType in bundleUrlTypes {
            
            if let urlName = urlType["CFBundleURLName"] as? String , urlName == "app_scheme" {
                
                guard let schemes = urlType["CFBundleURLSchemes"] as? [String] else {
                    return nil
                }
                
                scheme = schemes.first
                if scheme == "(null)" {
                    scheme = nil
                }
                
                
                return scheme
            }
        }
        
        return nil
    }
}
