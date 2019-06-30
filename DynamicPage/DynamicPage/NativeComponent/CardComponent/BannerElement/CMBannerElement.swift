//
//  CMBannerElement.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/11.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

class CMBannerElement: CMBaseElement {
    
    weak var delegate:CMBannerElementProtocol?
    
    var isAutoRun:Bool  {
        get {
            return autoRunning
        }
    }
    
    var isNeedAutoRun:Bool = false
    
    var autoRunning:Bool = false
    
    fileprivate var elementModel:CMElementModel?
    
    fileprivate lazy var bannerView:CMBannerView = {
        let view = CMBannerView(frame: CGRect.zero, collectionViewLayout: CMBannerElementLayout())
        
        return view
    }()
    
    fileprivate lazy var pageControll:UIView = {
        let view = UIView()
        
        return view
    }()
    
    fileprivate lazy var pageDotViews:[UIView] = {
        let views = [UIView]()
        
        return views
    }()
    
    fileprivate  var currentPage:Int = 0
    
    fileprivate var timer:Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let bannerModel = elementModel?.bannerStyle,bannerModel.autoRun {
            stopAutoBanner()
        }
    }
    
    //MARK: 私有方法
    private func setupBannerElement(model:CMElementModel) {
        elementModel = model
        backgroundColor = spaceColor
        
        addSubview(bannerView)
        addSubview(pageControll)
        
        layoutConstraint()
 
        let layout = CMBannerElementLayout()
        layout.delegate = self
        layout.scrollDirection = .horizontal
        bannerView.collectionViewLayout.invalidateLayout()
        bannerView.setCollectionViewLayout(layout, animated: true)
        bannerView.action = self
        bannerView.elements = model.elements
        bannerView.reloadData()
        
        setupPageControll(counts: model.elements?.count,bannerStyle: model.bannerStyle)
    }
    
    
    
    private func layoutConstraint() {
        bannerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        
        pageControll.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(20.0)
            make.bottom.equalToSuperview().offset(-12.0.cgFloat)
        }
    }
    
    /// 设置pageControll
    ///
    /// - Parameter counts: <#counts description#>
    fileprivate func setupPageControll(counts:Int?,bannerStyle:CMBannerStyle?) {
        
        if let banner = bannerStyle {
            isNeedAutoRun = banner.autoRun
            startAutoBanner()
        }
        
        if let count = counts {
            for item in 0..<count {
                appendDotView(item: item)
                layoutDotViewConstraint(item:item,count: count,style: bannerStyle)
            }
            
        }
    }
    
    fileprivate func appendDotView(item:Int) {
        let view = UIView()
        view.tag = item
        if item == currentPage {
            view.backgroundColor = UIColor.white
        } else {
            view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        }
        
        pageControll.addSubview(view)
        pageDotViews.append(view)
    }
    
    fileprivate func layoutDotViewConstraint(item:Int,count:Int,style:CMBannerStyle?) {
        
        if pageDotViews.count > 0,  item < pageDotViews.count,item == pageDotViews[item].tag {
            var dotMargin = 10.0.cgFloat
            var dotSize = 10.0.cgFloat
            
            if let style = style {
                if style.dotSize > 0.0 {
                    dotSize = style.dotSize.cgFloat
                }
                
                if style.dotMargin > 0.0 {
                    dotMargin = style.dotMargin.cgFloat
                }
            }
            
            let dotContentWidth = CGFloat(count) * dotSize + CGFloat(count - 1) * dotMargin
            
            let offSetCenterX = (dotSize + dotMargin) * CGFloat(item) + CGFloat(0.5 * dotSize) - CGFloat(dotContentWidth * 0.5)
            
            let view = pageDotViews[item]
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 5.0.cgFloat

            view.snp.makeConstraints { (make) in
                make.width.height.equalTo(dotSize)
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(offSetCenterX)
            }
        }
    }
    
    fileprivate func setPageControllPage(page:Int) {
        if page < pageDotViews.count,page != currentPage {
           let currentView = pageDotViews[currentPage]
           let view = pageDotViews[page]
            view.backgroundColor = UIColor.white
            currentView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            currentPage = page
        }
    }
    
    fileprivate func startAutoCarousel() {
        if isNeedAutoRun,isDisplayedInScreen() {
            autoRunning = true
            if timer == nil {
                let loopTimer = Timer.init(timeInterval: TimeInterval(1.0), target: self, selector: #selector(autoChangePage), userInfo: nil, repeats: true)
                RunLoop.main.add(loopTimer, forMode: .common)
    
                timer = loopTimer
            }
        }
    }
    
    fileprivate func stopAutoCarousel() {
        autoRunning = false
        if let loopTimer = timer,loopTimer.isValid {
            timer?.invalidate()
        }
        
        timer = nil
    }
    @objc fileprivate func autoChangePage() {
        
        // 如果在屏幕中显示才可以滚动
        if isDisplayedInScreen() {
            if let view = superview as? UICollectionView ,!view.isTracking,!view.isDragging {
                DispatchQueue.main.async { [weak self] in
                    self?.bannerView.processPageScroll()
                }
            }
        } else {
            stopAutoCarousel()
        }
    }
    
    // MARK: 外部公开方法
    func startAutoBanner() {
        DispatchQueue.global().async { [weak self] in
            self?.startAutoCarousel()
        }
    }
    
    func stopAutoBanner() {
        stopAutoCarousel()
    }
   
    //MARK： 公开方法
    class func cell(collectionView:UICollectionView,indexPath:IndexPath) -> CMBannerElement? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier(), for: indexPath)
        
        return cell as? CMBannerElement
    }
    
    class func element(collectionView:UICollectionView,indexPath:IndexPath,model:CMElementModel) -> CMBannerElement {
        let element = cell(collectionView: collectionView, indexPath: indexPath) ?? CMBannerElement()
        element.setupBannerElement(model: model)
        return element
    }
    
    class func indentifier() -> String {
        return "CMBannerElement.cell"
    }
    
    class func defalutBannerHeight() -> Float {
        return 360.0
    }
}

extension CMBannerElement : CMBannerViewProtocol {
    func cmbannerView(view: CMBannerView, didSelectItemWithModel model: CMElementModel) {
        delegate?.cmbannerElement(element: self, didSelectItemWithModel: model)
    }
    
    func cmbannerView(view: CMBannerView, scrollToPage page: Int) {
        if let view = superview as? UICollectionView ,!view.isTracking,!view.isDragging {
            setPageControllPage(page:page)
        }
    }
    
    func cmbannerView(view: CMBannerView, DidEndDragging scrollView: UIScrollView) {
        
    }
    
    func cmbannerView(view: CMBannerView, willBeginDragging scrollView: UIScrollView) {
        
    }
}

extension CMBannerElement:CMBannerElementLayoutProtocol {
    func cmbannerLayout(collectionView: UICollectionView?) -> CMElementModel? {
        return elementModel
    }
}

protocol CMBannerElementProtocol:NSObjectProtocol {
    func cmbannerElement(element:CMBannerElement,didSelectItemWithModel model: CMElementModel)
}
