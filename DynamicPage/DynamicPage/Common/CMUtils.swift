//
//  CMUtils.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/13.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

class CMUtils {
    ///获取数组中的最大值
    class func getArrayMaxOne<T:Comparable>(_ seq:[T]) ->T{
        assert(seq.count>0)
        
        return seq.reduce(seq[0]){
            max($0, $1)
        }
    }
     
}
