//
//  CMHorizontalLinerLayoutElement.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/15.
//  Copyright © 2019 YCM. All rights reserved.
//  水平线性滚动布局

import UIKit

class CMHorizontalLinerLayoutElement: CMBaseElement {
    
    weak var delegate:CMHorizontalLinerLayoutElementProtocol?
    
    /// 视图
    fileprivate lazy var cardView:UICollectionView = {
        let layout = CMHorizontalLineLayout()
        layout.delegate = self
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate var layoutModel:CMLayoutModel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 私有方法
    fileprivate func prepareLinerLayout(layoutModel model:CMLayoutModel?) {
        layoutModel = model
        backgroundColor = UIColor.white
        addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let layout = CMHorizontalLineLayout()
        layout.delegate = self
        layout.scrollDirection = .horizontal
        cardView.collectionViewLayout.invalidateLayout()
        cardView.setCollectionViewLayout(layout, animated: true)
        
        cardView.dataSource = self
        cardView.delegate = self
        
        registerComponentElement()
    }
    
    fileprivate func registerComponentElement() {
        cardView.register(CMBannerElement.self, forCellWithReuseIdentifier: CMBannerElement.indentifier())
        cardView.register(CMGoodsElement.self, forCellWithReuseIdentifier: CMGoodsElement.identifier())
        cardView.register(CMHorizontalLinerLayoutElement.self, forCellWithReuseIdentifier: CMHorizontalLinerLayoutElement.indentifier())
        cardView.register(CMImageElement.self, forCellWithReuseIdentifier: CMImageElement.identifier())
        cardView.register(CMMultlineTextElement.self, forCellWithReuseIdentifier: CMMultlineTextElement.identifier())
        cardView.register(CMBaseElement.self, forCellWithReuseIdentifier: CMBaseElement.identifier())
    }
    
    //MARK： 公开方法
    class func cell(collectionView:UICollectionView,indexPath:IndexPath) -> CMHorizontalLinerLayoutElement? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier(), for: indexPath)
        
        return cell as? CMHorizontalLinerLayoutElement
    }
    
    class func element(collectionView:UICollectionView,indexPath:IndexPath,layoutModel:CMLayoutModel?) -> CMHorizontalLinerLayoutElement {
        let element:CMHorizontalLinerLayoutElement = cell(collectionView: collectionView, indexPath: indexPath) ?? CMHorizontalLinerLayoutElement()
        element.prepareLinerLayout(layoutModel: layoutModel)
        return element
    }
    
    class func indentifier() -> String {
        return "CMHorizontalLinerLayoutElement.cell"
    }
}

extension CMHorizontalLinerLayoutElement:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let elements = layoutModel?.elements, indexPath.item < elements.count {
            let element = elements[indexPath.item]
            delegate?.cmhorizontalLinerLayoutElement(element: self, didSelectItemModel: element)
        }
    }
}

protocol CMHorizontalLinerLayoutElementProtocol:NSObjectProtocol {
    func cmhorizontalLinerLayoutElement(element:CMHorizontalLinerLayoutElement,didSelectItemModel model:CMElementModel)
}

extension CMHorizontalLinerLayoutElement:UICollectionViewDataSource {
    fileprivate func elementsForCollectionView(_ collectionView:UICollectionView,cellForItemAt indexPath:IndexPath,layoutModel:CMLayoutModel?) -> CMBaseElement {
        var element:CMBaseElement?
        
        if let Elements = layoutModel?.elements, indexPath.item < Elements.count {
            let elementModel = Elements[indexPath.item]
            
            switch elementModel.type {
            case .banner:
                element = CMBannerElement.element(collectionView: collectionView, indexPath: indexPath,model:elementModel)
            case .goods:
                element = CMGoodsElement.element(collectView: collectionView, indexPath: indexPath, model: elementModel)
            case .image:
                element = CMImageElement.element(collectView: collectionView, indexPath: indexPath,model: elementModel)
            case .text:
                element = CMMultlineTextElement.element(collectView: collectionView, indexPath: indexPath)
            default:
                break
            }
        }
        
        return element ?? CMBaseElement.element(collectView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        return elementsForCollectionView(collectionView, cellForItemAt: indexPath, layoutModel: layoutModel)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutModel?.elements?.count ?? 0
    }
}

// MARK: - 布局协议方法
extension CMHorizontalLinerLayoutElement:CMHorizontalLinerLayoutProtocol {
    func cmhorizontalLinerLayoutForLayoutModel(collectionView: UICollectionView) -> CMLayoutModel? {
        return layoutModel
    }
}

/// 线性水平布局
class CMHorizontalLineLayout:UICollectionViewFlowLayout {
    
    weak var delegate:CMHorizontalLinerLayoutProtocol?
    
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
        guard let layout = delegate?.cmhorizontalLinerLayoutForLayoutModel(collectionView: collectionView!) else {
            return
        }
        
        margin = UIEdgeInsets.edgeWithArray(array: layout.margin)
        padding = UIEdgeInsets.edgeWithArray(array: layout.padding)
        
        // 布局的边距
        let item = indexPath.item
        // 列数
        var column = 0
        
        let columnMargin = layout.columnMargin.cgFloat
        // 元素高度相关
        var itemWidth = CGFloat.zero
        var itemHeight = CGFloat.zero
        
        // 元素位置
        var elementMargin = UIEdgeInsets.edgeWithArray(array: [0])
        var elementPadding = UIEdgeInsets.edgeWithArray(array: [0])
        var elementWidth = CGFloat.zero
        var elementHeight = CGFloat.zero
        var elementWidthHeightRatio = CGFloat.zero
        
        if let Elements = layout.elements ,Elements.count > 0,item < Elements.count {
            let element = Elements[item]
            elementMargin = UIEdgeInsets.edgeWithArray(array: element.margin)
            elementPadding = UIEdgeInsets.edgeWithArray(array: element.padding)
            elementWidth = element.width.cgFloat
            elementHeight = element.height.cgFloat
            elementWidthHeightRatio = CGFloat(element.ratio)
            column = Elements.count
        }
        
        // 内容布局区其实位置和宽度
        let contentOrginX = margin.left + padding.left
        let contentOrginY = margin.top + padding.top
        let contentWidth =  ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset())
        
        // 限制每一列的宽度
        var limitWidth = layout.columnWidth.cgFloat
        if limitWidth > 0 {
            
            itemWidth = limitWidth - (elementMargin.getMaxXOffset() + elementPadding.getMaxXOffset())
    
            if item < column {
                limitWidth = limitWidth + columnMargin
            }
            addColumnWidth(width: Float(limitWidth), item: item)
        } else if layout.columnScreenWidthRatio > 0 {
            var columnMarginCount = Int(1.0 / layout.columnScreenWidthRatio)
            if columnMarginCount > 0 {
                columnMarginCount = columnMarginCount - 1
            }
            var limitWidth = (ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset() + CGFloat(columnMargin) * CGFloat(columnMarginCount))) * CGFloat(layout.columnScreenWidthRatio)
            itemWidth = limitWidth - (elementMargin.getMaxXOffset() + elementPadding.getMaxXOffset())
            
            if item < column {
                limitWidth = limitWidth + CGFloat(columnMargin)
            }
            
            addColumnWidth(width: Float(limitWidth), item: item)
        }
        
        
        // 高度布局
        if layout.lineHeight.cgFloat > 0 {
            itemHeight = layout.lineHeight.cgFloat - (margin.getMaxYOffset() + padding.getMaxYOffset() + elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset() )
            height = Float(layout.lineHeight.cgFloat)
        } else if layout.lineRatio > 0 {
            let lineHeight = CGFloat(layout.lineRatio) * ScreenWidth
            itemHeight = lineHeight - (margin.getMaxYOffset() + padding.getMaxYOffset() + elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
            height = Float(lineHeight)
        }
        
        let orignX =  contentOrginX + calcWidth(item: item)
        let orignY =  contentOrginY
        
        attribute.frame = CGRect(x: orignX, y: orignY, width: itemWidth, height: itemHeight)
    }
}

protocol CMHorizontalLinerLayoutProtocol:NSObjectProtocol {
    func cmhorizontalLinerLayoutForLayoutModel(collectionView:UICollectionView) -> CMLayoutModel?
}
