//
//  CMCardLayout.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/10.
//  Copyright © 2019 YCM. All rights reserved.
//  卡片式布局

import UIKit

class CMCardLayout: UICollectionViewFlowLayout {
    
    weak var delegate:CMCardLayoutProtocol?
    
    // MARK: 属性
    // 布局属性
    fileprivate var layouts:[CMCardLayoutModel] = {
        let layouts = [CMCardLayoutModel]()

        return layouts
    }()
    // 布局当前布局序号
    fileprivate var layoutSection = -1
    
    // MARK: 构造方法
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        
        if let width = collectionView?.frame.width {
            
            return CGSize(width: width, height: calucTotalLineHeight())
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    /// 计算总行高
    ///
    /// - Returns: <#return value description#>
    fileprivate func calucTotalLineHeight() -> CGFloat{
        if layouts.count > 0 {
           
            var totalHeight:Float = 0.0
            for section in 0..<layouts.count {
                let layout = layouts[section]
                for item in 0..<layout.lineHeights.count {
                    totalHeight = totalHeight + layout.lineHeights[item]
                }
                
                // 计算边框
                if section == layout.section {
                    let offsetY = Float(layout.margin.getMaxYOffset() + layout.padding.getMaxYOffset())
                    totalHeight = totalHeight + offsetY
                }
            }
            
            
            return CGFloat(totalHeight)
            
        }
        
        return 0.0
    }
    
    /// 计算叠加行高
    ///
    /// - Parameter line: <#line description#>
    /// - Returns: <#return value description#>
    fileprivate func calucLineHeight(section:Int, line:Int) ->CGFloat {
        var totalHeight:Float = 0.0
        
        if section < layouts.count {
            for sectionLayout in 0..<(section + 1) {
                let layout = layouts[sectionLayout]
                if sectionLayout == section {
                    if line <= layout.lineHeights.count {
                        for item in 0..<line {
                            totalHeight = totalHeight + layout.lineHeights[item]
                        }
                    }
                } else {
                    for item in 0..<layout.lineHeights.count {
                        totalHeight = totalHeight + layout.lineHeights[item]
                    }
                    totalHeight = totalHeight +  Float(layout.margin.getMaxYOffset() + layout.padding.getMaxYOffset())
                }
            }
        }
        
        return CGFloat(totalHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        processCardLayout(attribute: attribute, indexPath: indexPath)
        
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
    
    // MARK : 私有方法
    fileprivate func processCardLayout(attribute:UICollectionViewLayoutAttributes?,indexPath:IndexPath) {
        guard let layoutModel:CMLayoutModel = delegate?.cmcardLayout(collectionView: collectionView, layoutForSection: indexPath.section) else {
            return
        }
        
        
        let layout = layoutModel.layout ?? .FlowLayout
        
        // 添加布局属性
        if indexPath.section != layoutSection {
            layoutSection = indexPath.section
            
            let cardLayout = CMCardLayoutModel()
            cardLayout.layout = layout
            cardLayout.section = layoutSection
            cardLayout.margin = UIEdgeInsets.edgeWithArray(array: layoutModel.margin)
            cardLayout.padding = UIEdgeInsets.edgeWithArray(array: layoutModel.padding)
            layouts.append(cardLayout)
        }
        
        
        switch layout {
        case .LinerLayout:
            processLinerLayout(attribute: attribute, layoutModel: layoutModel, indexPath: indexPath)
        case .FlowLayout:
            processFlowLayout(attribute: attribute, layoutModel: layoutModel, indexPath: indexPath)
        case .WaterfallLayout:
            processWaterFallLayout(attribute: attribute, layoutModel: layoutModel, indexPath: indexPath)
        case .ShopWindowLayout:
            processShopWindowLayout(attribute: attribute, layoutModel: layoutModel, indexPath: indexPath)
        }
    }
    
    /// 获取列数
    ///
    /// - Parameter column: <#column description#>
    /// - Returns: <#return value description#>
    fileprivate func getColumn(column:Int) -> Int{
        if column < 1 {
            return 1
        }
        
        return column
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - values: <#values description#>
    ///   - column: <#column description#>
    ///   - index: <#index description#>
    /// - Returns: <#return value description#>
    fileprivate func getColumnRatiosAndOffsetY(values:[Float]?,column:Int,index:Int) -> (ratio:Float,offsetXRatio:Float) {
        let lineIndex  = index % column
  
        guard let ratios = values,ratios.count > 0,column == ratios.count else {
           
            return (1.0 / Float(column), Float(lineIndex) * (1.0 / Float(column)))
        }
        
        var ratio:Float = 0.0
        for (_,value) in ratios.enumerated() {
            if ratio + value > 1.0 {
                return (1.0 / Float(column), Float(lineIndex) * (1.0 / Float(column)))
            }
            ratio = ratio + value
        }
        
        var offSetXRatio:Float = 0.0
        
        for item in 0..<(index % column) {
            offSetXRatio = offSetXRatio + ratios[item]
        }
        
        return (ratios[index % column],offSetXRatio)
    }
    
    fileprivate func getLineMaxHeight(elements:[CMElementModel],elementWidth:Float,lineMargin:Float, column:Int,item:Int) -> Float{
        
        let lineItem = item % column;
        var itemLineHeights:[Float] = [0.0]
        let itemCounts = elements.count
        
        for index in (item - lineItem)..<(item - lineItem + column) {
            if index < elements.count {
                let element = elements[index]
                let elementMargin = UIEdgeInsets.edgeWithArray(array: element.margin)
                let elementPadding = UIEdgeInsets.edgeWithArray(array: element.padding)
                let ratioWidthHeightRatio = element.ratio
                let edgeY = Float(elementMargin.getMaxYOffset()  + elementPadding.getMaxYOffset())
                
                var itemHeight = Float(element.height.cgFloat) + edgeY
                if element.height == 0,ratioWidthHeightRatio > 0 {
                    itemHeight = elementWidth * ratioWidthHeightRatio + edgeY
                }
                
                itemLineHeights.append(itemHeight)
            }
            
        }
        
        if (item/column) < itemCounts / column {
            return CMUtils.getArrayMaxOne(itemLineHeights) + lineMargin
        }
        
        return CMUtils.getArrayMaxOne(itemLineHeights)
    }
    
    /// 找出一行中最大的高度
    ///
    /// - Parameters:
    ///   - elements: <#elements description#>
    ///   - column: <#column description#>
    ///   - item: <#item description#>
    fileprivate func getItemMaxLineHeight(style:CMLayoutStyle,elements:[CMElementModel],elementWidth:Float,lineMargin:Float, column:Int,item:Int,section:Int) -> Float {
        if layouts.count > 0 , section < layouts.count {
            let layout = layouts[section]
            
            if isLayout(style: style, section: section, checkLayout: layout) {
                let line = item / column;
                
                if layout.lineHeights.count > 0, (line + 1) <= layout.lineHeights.count {
                    return layout.lineHeights[line]
                } else {
                    let lineHeight = getLineMaxHeight(elements: elements, elementWidth: elementWidth,lineMargin: lineMargin,  column: column, item: item)
                    layout.lineHeights.append(lineHeight)
                    
                    return layout.lineHeights[line]
                }
            }
        }
        
        return 0.0
    }
    
    /// 添加行高
    ///
    /// - Parameters:
    ///   - height: <#height description#>
    ///   - item: <#item description#>
    fileprivate func addLineHeight(style:CMLayoutStyle,height:Float,item:Int,column:Int,section:Int) {
        if layouts.count > 0 , section < layouts.count {
            let layout = layouts[section]
            
            if isLayout(style: style, section: section, checkLayout: layout) {
                
                let line = item / column
                
                if layout.lineHeights.count > 0, (line + 1) <= layout.lineHeights.count {
                    return
                }
                
                layout.lineHeights.append(height)
            }
            
        }

    }
    
    /// 检查布局
    ///
    /// - Parameters:
    ///   - style: <#style description#>
    ///   - section: <#section description#>
    ///   - checkLayout: <#checkLayout description#>
    /// - Returns: <#return value description#>
    fileprivate func isLayout(style:CMLayoutStyle,section:Int,checkLayout:CMCardLayoutModel) -> Bool{
        if style == checkLayout.layout,section == checkLayout.section {
            return true
        }
        
        return false
    }
   
}


// MARK: - 线性布局
extension CMCardLayout {
    /// 线性布局
    ///
    /// - Parameters:
    ///   - attribute: <#attribute description#>
    ///   - layoutModel: <#layoutModel description#>
    ///   - item: <#item description#>
    fileprivate func processLinerLayout(attribute:UICollectionViewLayoutAttributes?,layoutModel:CMLayoutModel,indexPath:IndexPath) {
        // 布局的边距
        let item = indexPath.item
        let margin = UIEdgeInsets.edgeWithArray(array: layoutModel.margin)
        let padding = UIEdgeInsets.edgeWithArray(array: layoutModel.padding)
        let dicrection = layoutModel.layoutDirection
        // 元素高度相关
        var itemWidth = CGFloat.zero
        var itemHeight = CGFloat.zero
        var itemCounts = 0
        
        // 元素位置
        var elementMargin = UIEdgeInsets.edgeWithArray(array: [0])
        var elementPadding = UIEdgeInsets.edgeWithArray(array: [0])
        var elementWidth = CGFloat.zero
        var elementHeight = CGFloat.zero
        var elementWidthHeightRatio = CGFloat.zero
        
        switch dicrection {
        case .vertical:
            // 线性垂直布局只有一列
            let column = 1
            // 当前行
            let line = item
            // 行间距
            let lineMargin = layoutModel.lineMargin.cgFloat
            
            if let Elements = layoutModel.elements,Elements.count > 0,item < Elements.count {
                let element = Elements[item]
                elementMargin = UIEdgeInsets.edgeWithArray(array: element.margin)
                elementPadding = UIEdgeInsets.edgeWithArray(array: element.padding)
                elementHeight = element.height.cgFloat
                elementWidthHeightRatio = CGFloat(element.ratio)
                itemCounts = Elements.count
            }
            
            // 内容布局区其实位置和宽度
            let contentOrginX = margin.left + padding.left
            let contentOrginY = margin.top + padding.top
            let contentWidth =  ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset())
            
            // 由于只有一列，所以内容区宽度等于item宽度
            itemWidth = contentWidth
            
            // 固定高度的取值
            if elementHeight > 0 {
                itemHeight = elementHeight
            } else if elementWidthHeightRatio > 0 {
                if elementWidth > 0 {
                    itemHeight = elementWidth * elementWidthHeightRatio
                } else {
                    itemHeight = itemWidth * elementWidthHeightRatio
                }
            }
            
            // 如果有设置布局限制行高，或者限制比例
            var limitHeight = layoutModel.lineHeight.cgFloat
            if limitHeight > 0 {
                // 如果item 高度没有给，或者超过限制高度调整
                if limitHeight < itemHeight || itemHeight == 0 {
                    itemHeight = limitHeight - (elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
                }
                
                // 最后一行不用加
                if (item/column) < itemCounts / column {
                    limitHeight = limitHeight + lineMargin
                }
                
                addLineHeight(style:layoutModel.layout ?? .LinerLayout,height: Float(limitHeight) , item: item, column: column,section: indexPath.section)
            } else if layoutModel.lineRatio > 0 {
                let limitHeight = Float(ScreenWidth * CGFloat(layoutModel.lineRatio))
                if limitHeight < Float(itemHeight)  || itemHeight == 0 {
                    itemHeight = CGFloat(limitHeight) - (elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
                }
                
                var lineMaxHeight = Float(ScreenWidth) * layoutModel.lineRatio
                // 最后一行不用加
                if (item/column) < itemCounts / column {
                    lineMaxHeight = lineMaxHeight + Float(lineMargin)
                }
                
                addLineHeight(style:layoutModel.layout ?? .LinerLayout,height: lineMaxHeight, item: item, column: column,section: indexPath.section)
            } else {
                
                // 如果item 高度大于0
                if itemHeight > 0 {
                    var maxHeight =  itemHeight + CGFloat(elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
                    if (item/column) < itemCounts / column {
                        maxHeight = maxHeight + lineMargin
                    }
                    
                    addLineHeight(style:layoutModel.layout ?? .LinerLayout,height: Float(maxHeight), item: item, column: column,section: indexPath.section)
                }
            }
            
            let OffsetY = calucLineHeight(section: indexPath.section,line: line)
            let orignX =  contentOrginX
            let orignY =  contentOrginY + OffsetY
            
            attribute?.frame = CGRect(x: orignX, y: orignY, width: itemWidth, height: itemHeight)
            
        case .horizontal:
            // 水平方向的话
            var column = item
            let line = 1
            // 行间距
            if let Elements = layoutModel.elements,Elements.count > 0,item < Elements.count {
                column = Elements.count
            }
            
            // 内容布局区其实位置和宽度
            let contentOrginX = CGFloat(0.0)
            let contentOrginY = CGFloat(0.0)
            let contentWidth =  ScreenWidth
            
            // 由于只有一列，所以内容区宽度等于item宽度
            itemWidth = contentWidth
            
            // 水平布局一定要设置行高,或者比例
            let limitHeight = layoutModel.lineHeight.cgFloat
            if limitHeight > 0  {
                itemHeight = limitHeight
                
                addLineHeight(style:layoutModel.layout ?? .LinerLayout,height: Float(limitHeight), item: item, column: column,section: indexPath.section)
            }
            
            
            let OffsetY = calucLineHeight(section: indexPath.section,line: line - 1)
            let orignX =  contentOrginX
            let orignY =  contentOrginY + OffsetY
            
            attribute?.frame = CGRect(x: orignX, y: orignY, width: itemWidth, height: itemHeight)
            
        }
    }
}

// MARK: - 流式布局
extension CMCardLayout {
 
   
    /// 流式布局
    ///
    /// - Parameters:
    ///   - attribute: 布局属性
    ///   - layoutModel: 布局数据
    ///   - item: 布局中第item个元素和组件
    fileprivate func processFlowLayout(attribute:UICollectionViewLayoutAttributes?,layoutModel:CMLayoutModel,indexPath:IndexPath) {
        // 布局的边距
        let item = indexPath.item
        let margin = UIEdgeInsets.edgeWithArray(array: layoutModel.margin)
        let padding = UIEdgeInsets.edgeWithArray(array: layoutModel.padding)
        // 列数
        let column = getColumn(column: layoutModel.column)
        // 行数
        let line = item / column
        let columnMargin = layoutModel.columnMargin.cgFloat
        let lineMargin = layoutModel.lineMargin.cgFloat
        // 元素高度相关
        var itemWidth = CGFloat.zero
        var itemHeight = CGFloat.zero
        // 元素个数
        var itemCounts = 0
        
        // 元素位置
        var elementMargin = UIEdgeInsets.edgeWithArray(array: [0])
        var elementPadding = UIEdgeInsets.edgeWithArray(array: [0])
        var elementWidth = CGFloat.zero
        var elementHeight = CGFloat.zero
        var elementWidthHeightRatio = CGFloat.zero
        
        if let Elements = layoutModel.elements,Elements.count > 0,item < Elements.count {
            let element = Elements[item]
            elementMargin = UIEdgeInsets.edgeWithArray(array: element.margin)
            elementPadding = UIEdgeInsets.edgeWithArray(array: element.padding)
            elementWidth = element.width.cgFloat
            elementHeight = element.height.cgFloat
            elementWidthHeightRatio = CGFloat(element.ratio)
            itemCounts = Elements.count
        }
        
        // 内容布局区其实位置和宽度
        let contentOrginX = margin.left + padding.left
        let contentOrginY = margin.top + padding.top
        let contentWidth =  ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset()  + columnMargin * CGFloat(column - 1))
        
        // 取的每个item偏移信息
        let ratioInfos:(ratio:Float,offsetXRatio:Float) = getColumnRatiosAndOffsetY(values: layoutModel.columnRatios, column: column, index: item)
        
        let ratioItemWidth = contentWidth * CGFloat(ratioInfos.ratio)
        
        if elementWidth > 0 {
            itemWidth = elementWidth
        } else {
            itemWidth = ratioItemWidth - (elementMargin.getMaxXOffset() + elementPadding.getMaxXOffset())
        }
        
        
        // 固定高度的取值
        if elementHeight > 0 {
            itemHeight = elementHeight
        } else if elementWidthHeightRatio > 0 {
            itemHeight = elementWidth * elementWidthHeightRatio
        }
        
        // 如果有设置布局限制行高，或者限制比例
        var limitHeight = layoutModel.lineHeight.cgFloat
        if limitHeight > 0 {
            
            // 如果item 高度没有给，或者超过限制高度调整
            if limitHeight < itemHeight || itemHeight == 0 {
                itemHeight = limitHeight - (elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
            }
            
            // 最后一行不用加
            if (item/column) < itemCounts / column {
                limitHeight = limitHeight + lineMargin
            }
            
            addLineHeight(style:layoutModel.layout ?? .FlowLayout,height: Float(limitHeight) , item: item, column: column,section: indexPath.section)
        } else if layoutModel.lineRatio > 0 {
            var limitHeight = Float(ScreenWidth * CGFloat(layoutModel.lineRatio))
            if limitHeight < Float(itemHeight)  || itemHeight == 0 {
                itemHeight = CGFloat(limitHeight) - (elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
            }
            
            var lineMaxHeight = Float(ScreenWidth) * layoutModel.lineRatio
            // 最后一行不用加
            if (item/column) < itemCounts / column {
                lineMaxHeight = lineMaxHeight + Float(lineMargin)
            }
            
            addLineHeight(style:layoutModel.layout ?? .FlowLayout,height: lineMaxHeight, item: item, column: column,section: indexPath.section)
        } else {
            
                // 计算高度
                var maxLineHeight:Float = 0.0
                if let Elements = layoutModel.elements {
                    maxLineHeight = getItemMaxLineHeight(style:layoutModel.layout ?? .FlowLayout, elements:Elements , elementWidth: Float(itemWidth),lineMargin: Float(lineMargin), column: column, item: item,section: indexPath.section)
                }
            
                // 如果item 没有给固定高度，就用最大的高度布局
                if maxLineHeight > 0, itemHeight == 0 {
                    itemHeight = CGFloat(maxLineHeight) - CGFloat(elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset() + lineMargin)
                }
            
        }
        
        let currentColumn = item % column
        let OffsetY = calucLineHeight(section: indexPath.section,line: line)
        let orignX =  contentOrginX + contentWidth * CGFloat(ratioInfos.offsetXRatio) + columnMargin * CGFloat(currentColumn)
        let orignY =  contentOrginY + OffsetY
        
        
        attribute?.frame = CGRect(x: orignX, y: orignY, width: itemWidth, height: itemHeight)
    }
}

// MARK: - 橱窗布局
extension CMCardLayout {
    
    fileprivate func getShopWindowColumnRatioInfo(values:[Float]?,column:Int,shopWindowItemNum:Int,index:Int) -> (ratio:Float,offsetXRatio:Float) {
        
        var lineIndex  = index % shopWindowItemNum
        if lineIndex  > column - 1 {
            lineIndex = column - 1
        }
        
        guard let ratios = values,ratios.count > 0,column == ratios.count else {
            
            return (1.0 / Float(column), Float(lineIndex) * (1.0 / Float(column)))
        }
        
        var ratio:Float = 0.0
        for (_,value) in ratios.enumerated() {
            if ratio + value > 1.0 {
                return (1.0 / Float(column), Float(lineIndex) * (1.0 / Float(column)))
            }
            ratio = ratio + value
        }
        
        var offSetXRatio:Float = 0.0
        
        for item in 0..<lineIndex + 1 {
            offSetXRatio = offSetXRatio + ratios[item]
        }
        
        return (ratios[lineIndex],offSetXRatio)
    }
    
    /// 橱窗布局效果
    ///
    /// - Parameters:
    ///   - attribute: <#attribute description#>
    ///   - layoutModel: <#layoutModel description#>
    ///   - indexPath: <#indexPath description#>
    fileprivate func processShopWindowLayout(attribute:UICollectionViewLayoutAttributes?,layoutModel:CMLayoutModel,indexPath:IndexPath) {
        let item = indexPath.item
        let margin = UIEdgeInsets.edgeWithArray(array: layoutModel.margin)
        let padding = UIEdgeInsets.edgeWithArray(array: layoutModel.padding)
        // 列数
//        let column = getColumn(column: layoutModel.column)
        // 默认橱窗布局给2列了
        let column = 2
        // 橱窗布局只有三个元素
        let shopWindowMaxNum = 3
        
        // 行数
        let line = item / column
        let columnMargin = layoutModel.columnMargin.cgFloat
        let lineMargin = layoutModel.lineMargin.cgFloat
        // 元素高度相关
        var itemWidth = CGFloat.zero
        var itemHeight = CGFloat.zero
        // 元素个数
        var itemCounts = 0
        
        // 元素位置
        var elementMargin = UIEdgeInsets.edgeWithArray(array: [0])
        var elementPadding = UIEdgeInsets.edgeWithArray(array: [0])
        var elementWidth = CGFloat.zero
        var elementHeight = CGFloat.zero
        var elementWidthHeightRatio = CGFloat.zero
        
        if let Elements = layoutModel.elements,Elements.count > 0,item < Elements.count {
            let element = Elements[item]
            elementMargin = UIEdgeInsets.edgeWithArray(array: element.margin)
            elementPadding = UIEdgeInsets.edgeWithArray(array: element.padding)
            elementWidth = element.width.cgFloat
            elementHeight = element.height.cgFloat
            elementWidthHeightRatio = CGFloat(element.ratio)
            itemCounts = Elements.count
        }
        
        // 内容布局区其实位置和宽度
        let contentOrginX = margin.left + padding.left
        let contentOrginY = margin.top + padding.top
        let contentWidth =  ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset()  + columnMargin * CGFloat(column - 1))
        
        // 取的每个item偏移信息
        let ratioInfos:(ratio:Float,offsetXRatio:Float) = getShopWindowColumnRatioInfo(values: layoutModel.columnRatios, column: column,shopWindowItemNum: shopWindowMaxNum, index: item)
        
        let ratioItemWidth = contentWidth * CGFloat(ratioInfos.ratio)
        
        if elementWidth > 0 {
            itemWidth = elementWidth
        } else {
            itemWidth = ratioItemWidth - (elementMargin.getMaxXOffset() + elementPadding.getMaxXOffset())
        }
        
        // 固定高度的取值
        if elementHeight > 0 {
            itemHeight = elementHeight
        } else if elementWidthHeightRatio > 0 {
            itemHeight = elementWidth * elementWidthHeightRatio
        }
        
        
        // 在橱窗布局中的位置
        let itemInShopWindow = item % shopWindowMaxNum
        
        switch itemInShopWindow {
        case 0:
            var limitHeight = layoutModel.lineHeight.cgFloat
            if limitHeight > 0 {
                
                // 如果item 高度没有给，或者超过限制高度调整
                if limitHeight < itemHeight || itemHeight == 0 {
                    itemHeight = limitHeight - (elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
                }
                
                // 最后一行不用加
                if (item/shopWindowMaxNum) < itemCounts / shopWindowMaxNum {
                    limitHeight = limitHeight + lineMargin
                }
                
                addLineHeight(style:layoutModel.layout ?? .FlowLayout,height: Float(limitHeight) , item: item, column: shopWindowMaxNum,section: indexPath.section)
            } else if layoutModel.lineRatio > 0 {
                let limitHeight = Float(ScreenWidth * CGFloat(layoutModel.lineRatio))
                if limitHeight < Float(itemHeight)  || itemHeight == 0 {
                    itemHeight = CGFloat(limitHeight) - (elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
                }
                
                var lineMaxHeight = Float(ScreenWidth) * layoutModel.lineRatio
                // 最后一行不用加
                if (item/shopWindowMaxNum) < itemCounts / shopWindowMaxNum {
                    lineMaxHeight = lineMaxHeight + Float(lineMargin)
                }
                
                addLineHeight(style:layoutModel.layout ?? .FlowLayout,height: lineMaxHeight, item: item, column: shopWindowMaxNum,section: indexPath.section)
            } else {
                // 如果item 高度大于0
                if itemHeight > 0 {
                    var maxHeight =  itemHeight + CGFloat(elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())
                    if (item/shopWindowMaxNum) < itemCounts / shopWindowMaxNum {
                        maxHeight = maxHeight + lineMargin
                    }
                    
                    addLineHeight(style:layoutModel.layout ?? .LinerLayout,height: Float(maxHeight), item: item, column: shopWindowMaxNum,section: indexPath.section)
                } else {
                    itemHeight = itemWidth
                    let maxHeight = itemHeight + elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset()
                    addLineHeight(style: layoutModel.layout ?? .LinerLayout,height: Float(maxHeight), item: item, column: shopWindowMaxNum,section: indexPath.section)
                }
            }
            
            let currentLine = item / shopWindowMaxNum
            let OffsetY = calucLineHeight(section: indexPath.section,line: currentLine)
            let orignX =  contentOrginX
            let orignY =  contentOrginY + OffsetY
            
            
            attribute?.frame = CGRect(x: orignX, y: orignY, width: itemWidth, height: itemHeight)
        case 1,2:
            let limitHeight = layoutModel.lineHeight.cgFloat - lineMargin
            if limitHeight > 0 {
                // 如果item 高度没有给，或者超过限制高度调整
                if limitHeight < itemHeight || itemHeight == 0 {
                    itemHeight = (limitHeight - (elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())) * 0.5
                }
            } else if layoutModel.lineRatio > 0 {
                let limitHeight = Float(ScreenWidth * CGFloat(layoutModel.lineRatio)) - Float(lineMargin)
                if limitHeight < Float(itemHeight)  || itemHeight == 0 {
                    itemHeight = (CGFloat(limitHeight) - (elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset())) * 0.5
                }
            } else {
                if itemHeight > 0 {
                    let section = indexPath.section
                    let line = item / shopWindowMaxNum
                    if section < layouts.count {
                        let layout = layouts[section]
                        if line < layout.lineHeights.count {
                           var lineShopWidownMaxHeight = layout.lineHeights[line]
                            
                            if (item/shopWindowMaxNum) < itemCounts / shopWindowMaxNum {
                                lineShopWidownMaxHeight = lineShopWidownMaxHeight - Float(lineMargin)
                            }
                            itemHeight = 0.5 * CGFloat(lineShopWidownMaxHeight) - CGFloat(elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset() - lineMargin)
                        }
                        
                    }
                    
                } else {
                    itemHeight = (itemWidth - lineMargin) * 0.5
                }
            }
            
            let currentLine = item / shopWindowMaxNum
            var itemInshopWindowMargin = itemInShopWindow
            if itemInshopWindowMargin > column - 1 {
                itemInshopWindowMargin = column - 1
            }
            let OffsetY = calucLineHeight(section: indexPath.section,line: currentLine)
            let orignX =  contentOrginX + contentWidth * CGFloat(ratioInfos.offsetXRatio) + columnMargin * CGFloat(itemInshopWindowMargin)
            var orignY:CGFloat =  0.0
            if itemInShopWindow == 1 {
                orignY = contentOrginY + OffsetY
            } else {
                orignY = contentOrginY + OffsetY + itemHeight + CGFloat(lineMargin)
            }

            attribute?.frame = CGRect(x: orignX, y: orignY, width: itemWidth, height: itemHeight)
        default:
            break
        }
        
    }
}

// MARK: - 瀑布流布局
extension CMCardLayout {
    
    fileprivate func processWaterFallLayout(attribute:UICollectionViewLayoutAttributes?,layoutModel:CMLayoutModel,indexPath:IndexPath) {
        // 布局的边距
        let item = indexPath.item
        let margin = UIEdgeInsets.edgeWithArray(array: layoutModel.margin)
        let padding = UIEdgeInsets.edgeWithArray(array: layoutModel.padding)
        // 列数
        let column = getColumn(column: layoutModel.column)
        // 行数
        let line = item / column
        let columnMargin = layoutModel.columnMargin.cgFloat
        let lineMargin = layoutModel.lineMargin.cgFloat
        // 元素高度相关
        var itemWidth = CGFloat.zero
        var itemHeight = CGFloat.zero
        // 元素个数
        var itemCounts = 0
        
        // 元素位置
        var elementMargin = UIEdgeInsets.edgeWithArray(array: [0])
        var elementPadding = UIEdgeInsets.edgeWithArray(array: [0])
        var elementWidth = CGFloat.zero
        var elementHeight = CGFloat.zero
        var elementWidthHeightRatio = CGFloat.zero
        
        if let Elements = layoutModel.elements,Elements.count > 0,item < Elements.count {
            let element = Elements[item]
            elementMargin = UIEdgeInsets.edgeWithArray(array: element.margin)
            elementPadding = UIEdgeInsets.edgeWithArray(array: element.padding)
            elementWidth = element.width.cgFloat
            elementHeight = element.height.cgFloat
            elementWidthHeightRatio = CGFloat(element.ratio)
            itemCounts = Elements.count
        }
        
        // 内容布局区其实位置和宽度
        let contentOrginX = margin.left + padding.left
        let contentOrginY = margin.top + padding.top
        let contentWidth =  ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset()  + columnMargin * CGFloat(column - 1))
        
        // 取的每个item偏移信息
        let ratioInfos:(ratio:Float,offsetXRatio:Float) = getColumnRatiosAndOffsetY(values: layoutModel.columnRatios, column: column, index: item)
        
        let ratioItemWidth = contentWidth * CGFloat(ratioInfos.ratio)
        
        if elementWidth > 0 {
            itemWidth = elementWidth
        } else {
            itemWidth = ratioItemWidth - (elementMargin.getMaxXOffset() + elementPadding.getMaxXOffset())
        }
        
        
        // 固定高度的取值
        if elementHeight > 0 {
            itemHeight = elementHeight
        } else if elementWidthHeightRatio > 0 {
            itemHeight = elementWidth * elementWidthHeightRatio
        }
        
        // 瀑布流布局策略
        
        
        // 计算高度
        var maxLineHeight:Float = 0.0
        if let Elements = layoutModel.elements {
            maxLineHeight = getItemMaxLineHeight(style:layoutModel.layout ?? .FlowLayout, elements:Elements , elementWidth: Float(itemWidth),lineMargin: Float(lineMargin), column: column, item: item,section: indexPath.section)
        }
        
        // 如果item 没有给固定高度，就用最大的高度布局
        if maxLineHeight > 0, itemHeight == 0 {
            itemHeight = CGFloat(maxLineHeight) - CGFloat(elementMargin.getMaxYOffset() + elementPadding.getMaxYOffset() + lineMargin)
        }
        
        
        let currentColumn = item % column
        let OffsetY = calucLineHeight(section: indexPath.section,line: line)
        let orignX =  contentOrginX + contentWidth * CGFloat(ratioInfos.offsetXRatio) + columnMargin * CGFloat(currentColumn)
        let orignY =  contentOrginY + OffsetY
        
        
        attribute?.frame = CGRect(x: orignX, y: orignY, width: itemWidth, height: itemHeight)
    }
    
}

protocol CMCardLayoutProtocol:NSObjectProtocol {
    func cmcardLayout(collectionView:UICollectionView?,layoutForSection setion:Int) -> CMLayoutModel?
}


extension CMCardLayout {
    
    
    fileprivate func processGoodsElementLayout(layout:CMLayoutModel,element:CMElementModel,item:Int) -> Float {
        let margin = UIEdgeInsets.edgeWithArray(array: layout.margin)
        let padding = UIEdgeInsets.edgeWithArray(array: layout.padding)
        let columnMargin = layout.columnMargin.cgFloat
        // 列数
        var column = getColumn(column: layout.column)
        var itemWidth = CGFloat.zero
        
        switch layout.layout! {
        case .FlowLayout:
            let contentWidth =  ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset()  + columnMargin * CGFloat(column - 1))
            // 取的每个item偏移信息
            let ratioInfos:(ratio:Float,offsetXRatio:Float) = getColumnRatiosAndOffsetY(values: layout.columnRatios, column: column, index: item)
            
            let ratioItemWidth = contentWidth * CGFloat(ratioInfos.ratio)
            
            if element.width > 0 {
                itemWidth = element.width.cgFloat
            } else {
                itemWidth = ratioItemWidth - (UIEdgeInsets.edgeWithArray(array: element.margin).getMaxXOffset() + UIEdgeInsets.edgeWithArray(array: element.padding).getMaxXOffset())
            }
            
            return Float((itemWidth + CMGoodsElement.defaultGoodsTextAreaOffset()).orignValue)
            
        case .LinerLayout:
            
            if layout.layoutDirection == .vertical {
                let contentWidth =  ScreenWidth - (margin.getMaxXOffset() + padding.getMaxXOffset())
                itemWidth = contentWidth
                
                return Float((itemWidth + CMGoodsElement.defaultGoodsTextAreaOffset()).orignValue)
            }
            
        default:
            break
        }
        
        return element.height
    }
    
    fileprivate func resetLayoutWithElement(element:CMElementModel,layout:CMLayoutModel,item:Int) -> CMElementModel {
        var elementModel = element
        switch element.type {
        case .goods:
            element.height = processGoodsElementLayout(layout: layout, element: element, item: item)
        case .banner:
            element.height = CMBannerElement.defalutBannerHeight()
        default:
            break
        }
        return elementModel
    }
    
    /// 根据数据定制布局
    ///
    /// - Parameter layout: <#layout description#>
    /// - Returns: <#return value description#>
    func processLayoutWithElement(layout:CMLayoutModel) -> CMLayoutModel {
        var layoutModel = layout
        
        if let elements = layoutModel.elements, elements.count > 0 {
            for (index,var element) in elements.enumerated() {
                element = resetLayoutWithElement(element: element,layout: layout,item:index)
            }
        }
        
        return layoutModel
    }
}

