//
//  CMGoodElement.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/17.
//  Copyright © 2019 YCM. All rights reserved.
//  商品元素

import UIKit

class CMGoodsElement: CMBaseElement {
    
    fileprivate lazy var goodsImageView:UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    fileprivate lazy var priceLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    fileprivate lazy var deletePriceLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var goodsNameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor(hexString: "#333333")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initGoodsElement()
        layoutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 私有方法
    fileprivate func initGoodsElement() {
        addSubview(goodsImageView)
        addSubview(goodsNameLabel)
        addSubview(priceLabel)
        addSubview(deletePriceLabel)
        
        
    }
    
    fileprivate func layoutConstraint() {
        goodsImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(goodsImageView.snp.width)
        }
        
        goodsNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10.0.cgFloat)
            make.top.equalTo(goodsImageView.snp.bottom).offset(10.0.cgFloat)
            make.right.equalToSuperview().offset(-23.0.cgFloat)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10.0.cgFloat)
            make.top.equalTo(goodsNameLabel.snp.bottom).offset(15.0.cgFloat)
            make.right.equalTo(self.snp.centerX)
        }
        
        deletePriceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10.0.cgFloat)
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.left.equalTo(self.snp.centerX)
        }
    }
    
    fileprivate func setupGoodsElement(model:CMElementModel) {
        if let elements = model.elements, elements.count > 0 {
            for item in 0..<elements.count {
                let element = elements[item]
                
                switch element.type {
                case .image:
                    goodsImageView.contentMode = .scaleToFill
                    goodsImageView.kf.setImage(with: URL(string: element.imageUrl ?? ""), placeholder: UIImage.imageWithColor(color: spaceColor), options: [.forceRefresh], progressBlock: nil, completionHandler: nil)
                case .text:
                    processGoodsTextElement(element: element)
                default:
                    break;
                }
            }
        }
    }
    
    fileprivate func processGoodsTextElement(element:CMElementModel) {
        if let textStyle = element.textStyle {
            switch textStyle.type {
            case .title:
                goodsNameLabel.text = element.text
                
                if let colorStr = textStyle.color {
                    goodsNameLabel.textColor = UIColor(hexString: colorStr)
                } else {
                    goodsNameLabel.textColor = UIColor(hexString: "#333333")
                }
                
                if textStyle.fontSize > 0 {
                    goodsNameLabel.font = UIFont(name: "SourceHanSansCN-Regular", size: textStyle.fontSize.cgFloat)
                } else {
                    goodsNameLabel.font = UIFont(name: "SourceHanSansCN-Regular", size: 26.0.cgFloat)
                }
            case .price:
                priceLabel.text = element.text
                if let colorStr = textStyle.color {
                    priceLabel.textColor = themeTintColor ?? UIColor(hexString: colorStr)
                } else {
                    priceLabel.textColor = themeTintColor ?? UIColor(hexString: "#ED0535")
                }
                
                if textStyle.fontSize > 0 {
                    priceLabel.font = UIFont(name: "SourceHanSansCN-Regular", size: textStyle.fontSize.cgFloat)
                } else {
                    priceLabel.font = UIFont(name: "SourceHanSansCN-Regular", size: 30.0.cgFloat)
                }
                
            case .deletePrice:
                var attribute:[NSAttributedString.Key:Any] = [NSAttributedString.Key:Any]()
                attribute.updateValue(NSUnderlineStyle.single.rawValue, forKey: NSAttributedString.Key.strikethroughStyle)
                
                var color = UIColor(hexString: "#B2B2B2")
                if let colorStr = textStyle.color {
                    color = UIColor(hexString: colorStr)
                }
                attribute.updateValue(color, forKey: NSAttributedString.Key.foregroundColor)
                attribute.updateValue(color, forKey: NSAttributedString.Key.strikethroughColor)
                
                var font = UIFont(name: "SourceHanSansCN-Regular", size: 24.0.cgFloat) ?? UIFont.systemFont(ofSize: 24.0.cgFloat)
                if textStyle.fontSize > 0 {
                    font = UIFont(name: "SourceHanSansCN-Regular", size: textStyle.fontSize.cgFloat) ?? UIFont.systemFont(ofSize: textStyle.fontSize.cgFloat)
                }
                attribute.updateValue(font, forKey: NSAttributedString.Key.font)
                
                let attributeText = NSAttributedString(string: element.text ?? "", attributes: attribute)
                
                deletePriceLabel.attributedText = attributeText
                
            default:
                break;
            }
        }
    }
    
    // MARK：外部方法
    override class func cell(collectView:UICollectionView,indexPath:IndexPath) -> CMGoodsElement? {
        return collectView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath) as? CMGoodsElement
    }
    
    class func element(collectView:UICollectionView,indexPath:IndexPath,model:CMElementModel) -> CMGoodsElement {
        let element = cell(collectView: collectView, indexPath: indexPath)
        element?.setupGoodsElement(model: model)
        return element ?? CMGoodsElement()
    }
    
    override class func identifier() -> String{
        return "CMGoodsElement.cell"
    }
    
    class func defaultGoodsTextAreaOffset() -> CGFloat {
        return (10.0.cgFloat + 30.0.cgFloat * 2 + 15.0.cgFloat + 26.0.cgFloat + 10.0.cgFloat)
    }
}
