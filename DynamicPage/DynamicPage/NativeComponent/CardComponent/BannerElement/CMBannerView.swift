//
//  CMBannerView.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/11.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

let timeInterval = 3.0
let numberOfPage = 0
let pageLoopCount = 1000
let cellHeight:CGFloat = 300.0
let pageControllOffsetBottom:CGFloat = 12.0

class CMBannerView: UICollectionView {
    
    weak var action:CMBannerViewProtocol?
    
    fileprivate var timeTicks:Int = 0;
    // 元素
    var elements:[CMElementModel]? {
        didSet {
            if let Elements = elements {
                scrollToItem(at: IndexPath(item: Elements.count * pageLoopCount / 2, section: 0), at: .left, animated: true)
            }
        }
    }
    
    
    //MARK : 构造方法
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupBannerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    //MARK： 私有方法
    private func setupBannerView() {
        backgroundColor = spaceColor
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        delegate = self
        dataSource = self
        
        register(CMBannerCell.self, forCellWithReuseIdentifier: CMBannerCell.identifier())
        setupPageControll()
    }
    
    private func setupPageControll() {
        if let Elements = elements {
            scrollToItem(at: IndexPath(item: Elements.count * pageLoopCount / 2, section: 0), at: .left, animated: true)
        }
    }
    
    
    func processPageScroll() {
        if !isDragging {
            timeTicks = timeTicks + 1
            if timeTicks == Int(timeInterval) {
                timeTicks = 0
                
                if let current = indexPathsForVisibleItems.last,let pages = elements?.count {
                    var item = current.item + 1
                    
                    if item > pages * pageLoopCount / 2 + pageLoopCount * (pages - 1) / 2 {
                        item = pages + pageLoopCount / 2;
                    }
                    
                    scrollToItem(at: IndexPath(item: item, section: 0), at: .left, animated: true)
                }
            }
        }
       
    }
    
}

protocol CMBannerViewProtocol:NSObjectProtocol {
    func cmbannerView(view:CMBannerView,scrollToPage page:Int)
    
    func cmbannerView(view:CMBannerView,willBeginDragging scrollView:UIScrollView)
    
    func cmbannerView(view:CMBannerView,DidEndDragging scrollView:UIScrollView)
    
    func cmbannerView(view:CMBannerView,didSelectItemWithModel model:CMElementModel)
}

extension CMBannerView:UICollectionViewDelegate {
    
    fileprivate func processBannerPage(_ scrollView:UIScrollView) {
        if let Elements = elements {
            let currentPage = (scrollView.contentOffset.x / scrollView.bounds.width + 0.5).truncatingRemainder(dividingBy: CGFloat(Elements.count))
    
            action?.cmbannerView(view: self, scrollToPage: Int(currentPage))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        processBannerPage(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        action?.cmbannerView(view: self, willBeginDragging: scrollView)
        timeTicks = 0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        action?.cmbannerView(view: self, DidEndDragging: scrollView)
    }
}

extension CMBannerView:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = (elements?.count ?? 0) * pageLoopCount
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CMBannerCell.cell(collectView: collectionView,indexPath: indexPath)
        if let elements = elements{
            let element = elements[indexPath.item % elements.count]
            if element.type == .image {
                cell?.imageUrl = element.imageUrl
            }
        }
        cell?.tag = indexPath.item
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCellWithGesture(_:)))
        cell?.addGestureRecognizer(tap)
        
        return cell ?? CMBannerCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let elements = elements{
            let element = elements[indexPath.item % elements.count]
            action?.cmbannerView(view: self, didSelectItemWithModel: element)
        }
    }
}

extension CMBannerView {
    @objc fileprivate func didTapCellWithGesture(_ gesture:UITapGestureRecognizer) {
        if let cell:CMBannerCell = gesture.view as? CMBannerCell, let indexPath = self.indexPath(for: cell) {
            
            collectionView(self, didSelectItemAt: indexPath)
        }
    }
}

class CMBannerElementLayout:UICollectionViewFlowLayout {
    
     weak var delegate:CMBannerElementLayoutProtocol?

    fileprivate var widths:[Float] = {
        let widths = [Float]()
        
        return widths
    }()
    
    fileprivate var height:Float = 0.0
    
    fileprivate var margin = UIEdgeInsets.zero
    
    fileprivate var padding = UIEdgeInsets.zero
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        processLinerLayout(attribute: attribute, indexPath: indexPath)
        
        return attribute
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        if let sections = collectionView?.numberOfSections {
            for section in 0..<sections {
                if let items = collectionView?.numberOfItems(inSection: section) {
                    for item in 0..<items {
                        if let attribute = layoutAttributesForItem(at: IndexPath.init(item: item, section: section)) {
                            attributes.append(attribute)
                        }
                    }
                }
            }
        }
        
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        
        if height > 0,widths.count > 0 {
            let width = calcTotalWidth()
            
            return CGSize(width: width, height: CGFloat(height))
        }
        
        return CGSize(width: 0.0, height: 0.0)
    }
    
    // MARK: 布局调整
    
    fileprivate func calcTotalWidth() -> CGFloat {
        var totalHeight:CGFloat = 0.0
        
        for index in 0..<widths.count {
            totalHeight = totalHeight + CGFloat(widths[index])
        }
        
        totalHeight = totalHeight + (margin.getMaxXOffset() + padding.getMaxXOffset())
        
        return totalHeight
    }
    
    fileprivate func calcWidth(item:Int) -> CGFloat {
        var totalHeight:Float = 0.0
        if item < widths.count {
            for index in 0..<item {
                totalHeight = totalHeight + widths[index]
            }
        }
        
        return CGFloat(totalHeight)
    }
    
    /// 添加数据
    ///
    /// - Parameters:
    ///   - width: <#width description#>
    ///   - item: <#item description#>
    fileprivate func addColumnWidth(width:Float,item:Int) {
        if widths.count > 0, (item + 1) <= widths.count {
            return
        }
        
        widths.append(width)
    }
    
    fileprivate func processLinerLayout(attribute: UICollectionViewLayoutAttributes, indexPath: IndexPath) {
        guard let view = collectionView, let layout = delegate?.cmbannerLayout(collectionView: view) else {
            return
        }
    
        margin = UIEdgeInsets.edgeWithArray(array: layout.margin)
        padding = UIEdgeInsets.edgeWithArray(array: layout.padding)

        
        // 布局的边距
        let item = indexPath.item
        
        // 元素高度相关
        var itemWidth = CGFloat.zero
        var itemHeight = CGFloat.zero
        
        // 内容布局区其实位置和宽度
        let contentOrginX = margin.left + padding.left
        let contentOrginY = margin.top + padding.top
        let contentWidth =  ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset())
        
        // 限制每一列的宽度
        itemWidth = contentWidth
        addColumnWidth(width: Float(contentWidth), item: item)
        
        
        // 高度布局
        if layout.height.cgFloat > 0.0 {
            itemHeight = layout.height.cgFloat - (margin.getMaxYOffset() + padding.getMaxYOffset())
            height = Float(layout.height.cgFloat)
        } else if layout.ratio > 0 {
            let lineHeight = CGFloat(layout.ratio) * contentWidth
            itemHeight = lineHeight - (margin.getMaxYOffset() + padding.getMaxYOffset())
            height = Float(lineHeight)
        }
        
        let orignX =  contentOrginX + calcWidth(item: item)
        let orignY =  contentOrginY
        
        attribute.frame = CGRect(x: orignX, y: orignY, width: itemWidth, height: itemHeight)
    }
    
}

protocol CMBannerElementLayoutProtocol:NSObjectProtocol {
    func cmbannerLayout(collectionView:UICollectionView?) -> CMElementModel?
    
}
