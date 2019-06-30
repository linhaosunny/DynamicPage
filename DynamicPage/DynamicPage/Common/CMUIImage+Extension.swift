//
//  CMUIImage+Extension.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/17.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageWithColor(color:UIColor) -> UIImage?
    {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func imageWithView(view:UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.bounds.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 图片缩放
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - size: <#size description#>
    /// - Returns: <#return value description#>
    class func imageWithSize(image:UIImage?,size:CGSize) ->UIImage? {
  
        let scale = UIScreen.main.scale
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        image?.draw(in: rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
