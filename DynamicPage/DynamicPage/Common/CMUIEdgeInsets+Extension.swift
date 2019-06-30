//
//  CMUIEdgeInset+Extension.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/13.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    /// 获取垂直方向最大偏移
    func getMaxYOffset() -> CGFloat {
        return self.bottom + self.top
    }
    
    /// 获取水平方向最大偏移
    func getMaxXOffset() -> CGFloat {
        return self.left + self.right
    }
    
    /// 将margin,padding,等数组数据转换成UIEdgeInsets类型
    ///
    /// - Parameter array: <#array description#>
    /// - Returns: <#return value description#>
    static func edgeWithArray( array:[Float]?) -> UIEdgeInsets {
        var edge = UIEdgeInsets.zero
        
        if let edges = array,edges.count > 0 {
            switch edges.count {
            case 1:
                let value = edges[0].cgFloat
                edge = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
            case 2:
                let valueX = edges[0].cgFloat
                let valueY = edges[1].cgFloat
                
                edge = UIEdgeInsets(top: valueY, left: valueX, bottom: valueY, right: valueX)
            case 3:
                let valueLeft = edges[0].cgFloat
                let valueY = edges[1].cgFloat
                let valueRight = edges[2].cgFloat
                edge = UIEdgeInsets(top: valueY, left: valueLeft, bottom: valueY, right: valueRight)
            case 4:
                let valueTop = edges[0].cgFloat
                let valueLeft = edges[1].cgFloat
                let valueBottom = edges[2].cgFloat
                let valueRight = edges[3].cgFloat
                edge = UIEdgeInsets(top: valueTop, left: valueLeft, bottom: valueBottom, right: valueRight)
            default:
                break
            }
        }
        
        return edge
    }
}
