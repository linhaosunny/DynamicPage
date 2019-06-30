//
//  RefreshHeaderGlobalAnimator.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/7/9.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit
import ESPullToRefresh

class RefreshHeaderAnimator: UIView,ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    let imageWidth:CGFloat = 60.0.cgFloat
    public let RefreshDescription: String = "下拉刷新"
    public let RefreshingDescription: String     = "刷新中..."
    
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var view: UIView { return self }
    public var duration: TimeInterval = 0.3
    public var trigger: CGFloat = 56.0
    public var executeIncremental: CGFloat = 56.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    var totalDuration:TimeInterval = 0.0
    
    private lazy var sourceImages:[UIImage]? = {

        guard let path = Bundle.main.path(forResource: "refresh_red", ofType: ".gif") else {
            return nil
        }
        
        guard let data = NSData(contentsOfFile: path) else {
            return nil
        }
        
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else {
            return nil
        }
        
        let imageCount = CGImageSourceGetCount(imageSource)
        
        // 遍历所有图片
        var images = [UIImage]()
        
        
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
        
        
        return images
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView.init()
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageWidth)
            make.top.equalToSuperview()
            make.centerX.equalTo(self.snp.centerX)
        }
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        imageView.center = self.center
        titleLabel.text = RefreshingDescription
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            
            let y = (self.bounds.size.height - self.imageWidth) * 0.5
            self.imageView.snp.updateConstraints { (make) in
                make.top.equalTo(y)
                make.height.equalTo(self.imageWidth)
            }
            
        }, completion: {  (finished) in
            if let images = self.sourceImages {
                self.imageView.animationDuration = self.totalDuration
                self.imageView.animationRepeatCount = 0
                self.imageView.animationImages = images
                self.imageView.startAnimating()
            }
        })
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        
        imageView.stopAnimating()
        imageView.image = sourceImages?.first
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.refresh(view: view, progressDidChange: 0.0)
        }, completion: { [weak self] (finished) in
            self?.titleLabel.text = ""
        })
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        let p = max(0.0, min(1.0, progress))
        
        if let images = sourceImages {
            
            imageView.image = images[ Int(CGFloat(images.count - 1) * p)]
        }
    }
    
    fileprivate func jumpUpAnimator(_ p:CGFloat) {
        titleLabel.text = RefreshDescription
        let y = (self.bounds.size.height - imageWidth * p) * 0.5
        imageView.snp.updateConstraints { (make) in
            make.top.equalTo(y)
            make.height.equalTo(imageWidth * p)
        }
    }
    
    fileprivate func animatorToStart() {
        if let images = sourceImages {
            var reseverImages = [UIImage]()
            for image in images.reversed() {
                reseverImages.append(image)
            }

            imageView.animationDuration = totalDuration
            imageView.animationRepeatCount = 1
            imageView.animationImages = reseverImages
            imageView.image = sourceImages?.first
            imageView.startAnimating()
        }
    }
    
    fileprivate func animatorToEnd() {
        if let images = sourceImages {
            imageView.animationDuration = totalDuration
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = sourceImages?.last

            imageView.startAnimating()
        }
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
   
        switch state {
        case .pullToRefresh:
            
            break
        case .releaseToRefresh:

            break
        default:
            break
        }
    }
    
    
}
