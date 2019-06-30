//
//  RefreshFooterNormalAnimator.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/6/22.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit
import ESPullToRefresh

class RefreshFooterAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    public let loadingMoreDescription: String = "加载更多"
    public let noMoreDataDescription: String  = "没有更多数据"
    public let loadingDescription: String     = "加载中..."
    
    public var view: UIView {
        return self
    }
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var trigger: CGFloat = 48.0
    public var executeIncremental: CGFloat = 48.0
    public var state: ESRefreshViewState = .autoRefreshing
    
    private let topLine: UIView = {
        let topLine = UIView.init(frame: CGRect.zero)
        topLine.backgroundColor = UIColor.clear
        return topLine
    }()
    private let bottomLine: UIView = {
        let bottomLine = UIView.init(frame: CGRect.zero)
        bottomLine.backgroundColor = UIColor.clear
        return bottomLine
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    

    
//    private let indicatorView: AnimatorIndactorView = {
//        let indicatorView = AnimatorIndactorView("load_red")
//        indicatorView.isHidden = true
//        return indicatorView
//    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(indicatorView)
        addSubview(topLine)
        addSubview(bottomLine)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        
        if state != .autoRefreshing {
            indicatorView.startAnimating()
            indicatorView.isHidden = false
            
            titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX).offset(80.0.cgFloat)
            }
        }
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        
        if state != .autoRefreshing {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
            
            titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX).offset(0)
            }
        } else {
            self.state = .pullToRefresh
        }
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        
        if state != .autoRefreshing {
            switch state {
            case .refreshing :
                titleLabel.text = loadingDescription
                break
            case .autoRefreshing :
                titleLabel.text = loadingDescription
                break
            case .noMoreData:
                titleLabel.text = noMoreDataDescription
                break
            default:
                titleLabel.text = loadingMoreDescription
                break
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
   
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX).offset(0.0.cgFloat)
        }
        
        indicatorView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(titleLabel.snp.left).offset(-20.cgFloat)
            make.width.equalTo(35.0.cgFloat)
            make.height.equalTo(35.0.cgFloat)
        }
        
    }
    
}

