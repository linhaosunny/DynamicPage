//
//  CMSearchElement.swift
//  DynamicPage
//
//  Created by sunshine.lee on 2019/6/26.
//  Copyright © 2019 sunshine.lee. All rights reserved.
//

import UIKit

class CMSearchElement: CMBaseElement {
    
    weak var delegate:CMSearchElementProtocol?
    
    fileprivate var elementModel:CMElementModel?
    
    fileprivate lazy var searchButton:UIButton = {
       let button = UIButton(type: .custom)
        
        return button
    }()
    
    //MARK: 私有方法
    private func setupSearchElement(model:CMElementModel) {
        backgroundColor = UIColor.white
        elementModel = model
        
        addSubview(searchButton)
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.setTitle("搜索", for: .normal)
        searchButton.setTitleColor(UIColor.init(hexString: "#B2B2B2"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonClick(_:)), for: .touchUpInside)
        
        layoutConstraint(model: model)
    }
    
    private func layoutConstraint(model:CMElementModel) {
        
        searchButton.layer.cornerRadius = 40.0.cgFloat
        searchButton.layer.masksToBounds = true
        searchButton.layer.borderWidth = 2.0.cgFloat
        searchButton.layer.borderColor = spaceColor.cgColor
        searchButton.backgroundColor = spaceColor
        
        searchButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(40.0.cgFloat)
            make.top.equalToSuperview().offset(20.0.cgFloat)
            make.right.equalToSuperview().offset(-40.0.cgFloat)
            make.bottom.equalToSuperview().offset(-20.0.cgFloat)
        }
        
        if searchButton.imageView != nil {
            searchButton.imageView?.snp.updateConstraints({ (make) in
                make.width.height.equalTo(45.0.cgFloat)
                make.centerY.equalToSuperview()
                if let titleLabel = searchButton.titleLabel {
                    make.right.equalTo(titleLabel.snp.left).offset(-15.0.cgFloat)
                } else {
                    make.centerX.equalToSuperview()
                }
                
            })
        }
    }
    
    //MARK： 公开方法
    class func cell(collectionView:UICollectionView,indexPath:IndexPath) -> CMSearchElement? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier(), for: indexPath)
        
        return cell as? CMSearchElement
    }
    
    class func element(collectionView:UICollectionView,indexPath:IndexPath,model:CMElementModel) -> CMSearchElement {
        let element = cell(collectionView: collectionView, indexPath: indexPath) ?? CMSearchElement()

        element.setupSearchElement(model:model)
        return element
    }
    
    class func indentifier() -> String {
        return "CMSearchElement.cell"
    }
    
    class func defalutSearchHeight() -> Float {
        return 120.0
    }
}

extension CMSearchElement {
    @objc fileprivate func searchButtonClick(_ button:UIButton) {
        delegate?.cmsearchElement(element: self, didClickSearchWith: elementModel)
    }
}

protocol CMSearchElementProtocol:NSObjectProtocol {
    func cmsearchElement(element:CMSearchElement,didClickSearchWith model:CMElementModel?)
}
