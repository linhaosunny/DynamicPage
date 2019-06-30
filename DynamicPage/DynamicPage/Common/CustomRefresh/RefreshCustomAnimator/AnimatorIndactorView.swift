//
//  AnimatorIndactorView.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/6/22.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit

class AnimatorIndactorView: UIImageView {
    
    // MARK: 构造方法
    convenience init(_ fileName:String) {
        self.init()
        
        setupIndactorView(fileName)
    }
    
    // MARK: 私有方法
    fileprivate func setupIndactorView(_ fileName:String) {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: ".gif") else {
            return
        }
        
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else {
            return
        }
        
        let imageCount = CGImageSourceGetCount(imageSource)
        
        // 遍历所有图片
        var images = [UIImage]()
        
        var totalDuration:TimeInterval = 0.0
        
        for i in 0..<imageCount {
            // 取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {
                continue
            }
            
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            // 取出持续时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else {
                continue
            }
            
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else {
                continue
            }
            
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber  else {
                continue
            }
            
            totalDuration = totalDuration + TimeInterval(frameDuration.doubleValue)
        }
        
        animationImages = images
        animationDuration = totalDuration
        animationRepeatCount = 0
    }
    
    

}
