//
//  RefreshBlackViewAnimator.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/5/24.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  空的动画

import UIKit
import ESPullToRefresh

open class RefreshBlackViewAnimator: UIView , ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    public var view: UIView {
        return self
    }
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var trigger: CGFloat = 48.0
    public var executeIncremental: CGFloat = 48.0
    public var state: ESRefreshViewState = .pullToRefresh

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
 
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
    
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
       
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
       
    }
}
