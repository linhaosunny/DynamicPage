//
//  UIImage+Extension.swift
//  EHViewer
//
//  Created by 望了不忘 on 2019/1/28.
//  Copyright © 2019 WangleBuWang. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 根据机型尺寸获取启动图片
    class func getLaunchImage() -> UIImage? {
        let size = UIScreen.main.bounds.size
        
        var launchImage = ""
        let orientation = "Portrait"
        let imageInfoArray = Bundle.main.infoDictionary!["UILaunchImages"]
        for dict:Dictionary<String,String> in imageInfoArray as! Array  {
            let imageSize = NSCoder.cgSize(for: dict["UILaunchImageSize"]!)
            if __CGSizeEqualToSize(imageSize, size) && orientation == dict["UILaunchImageOrientation"]! as String {
                launchImage = dict["UILaunchImageName"]!
            }
            
        }
        
        return UIImage(named: launchImage)
    }
}
