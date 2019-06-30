//
//  CMUIFont+Extension.swift
//  ChattingManage
//
//  Created by 李莎鑫 on 2019/5/19.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// 思源字体
    ///
    /// - Parameter size: <#size description#>
    /// - Returns: <#return value description#>
    class func defaultCustomFont(_ size:CGFloat ) -> UIFont? {
        return UIFont(name: "SourceHanSansCN-Regular", size: size)
    }
}
