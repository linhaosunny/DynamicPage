//
//  String+Extension.swift
//  EHViewer
//
//  Created by 望了不忘 on 2019/3/4.
//  Copyright © 2019 WangleBuWang. All rights reserved.
//

import UIKit

extension String {
    
    /// 字符串的url地址转义
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
