//
//  ViewController.swift
//  DynamicPage
//
//  Created by sunshine.lee on 2019/6/25.
//  Copyright © 2019 sunshine.lee. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class ViewController: UIViewController {

    fileprivate var cardLayout:CMCardLayout?
    
    lazy var cardView:UICollectionView = {
        let layout = CMCardLayout()
        layout.delegate = self
        let view = UICollectionView(frame: self.view.bounds,collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    fileprivate lazy var layoutModels:[CMLayoutModel] = {
        let models = [CMLayoutModel]()
        
        return models
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPage()
    }

    fileprivate func addPage() {
        view.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let layout = CMCardLayout()
        layout.delegate = self
        layout.scrollDirection = .vertical
        cardView.collectionViewLayout.invalidateLayout()
        cardView.setCollectionViewLayout(layout, animated: true)
        cardLayout = layout
        cardView.dataSource = self
        cardView.delegate = self
        
        registerComponentElement()
        
   
        loadDataFromMock()

    }

    fileprivate func registerComponentElement() {
        cardView.register(CMBannerElement.self, forCellWithReuseIdentifier: CMBannerElement.indentifier())
        cardView.register(CMGoodsElement.self, forCellWithReuseIdentifier: CMGoodsElement.identifier())
        cardView.register(CMSearchElement.self, forCellWithReuseIdentifier: CMSearchElement.indentifier())
        cardView.register(CMHorizontalLinerLayoutElement.self, forCellWithReuseIdentifier: CMHorizontalLinerLayoutElement.indentifier())
        cardView.register(CMImageElement.self, forCellWithReuseIdentifier: CMImageElement.identifier())
        cardView.register(CMMultlineTextElement.self, forCellWithReuseIdentifier: CMMultlineTextElement.identifier())
        cardView.register(CMBaseElement.self, forCellWithReuseIdentifier: CMBaseElement.identifier())
        
    }
    
    /// 加载本地json
    fileprivate func loadDataFromMock() {
        let fileName = "mallHome"
        if let mockPath = Bundle.main.path(forResource: fileName, ofType: "json"),let mockString = try? String(contentsOfFile: mockPath) {
            let json = JSON.init(parseJSON: mockString)
            let jsonArrayOject = json.dictionary?["data"]?.dictionary?["cards"]?.arrayObject
            let models:[CMLayoutModel] = CMJsonUtil.arrayToModels(jsonArrayOject, CMLayoutModel.self)
            if models.count > 0 {
                layoutModels = models
            }
        }
    }
}

extension ViewController:UICollectionViewDataSource {
    
    
    fileprivate func elementsForCollectionView(_ collectionView:UICollectionView,cellForItemAt indexPath:IndexPath,layoutModel:CMLayoutModel?) -> CMBaseElement? {
        
        var element:CMBaseElement?
        
        if let Elements = layoutModel?.elements, indexPath.item < Elements.count {
            let elementModel = Elements[indexPath.item]
            
            switch elementModel.type {
            case .banner:
                let bannerElement:CMBannerElement = CMBannerElement.element(collectionView: collectionView, indexPath: indexPath,model:elementModel)
                bannerElement.delegate = self
                element = bannerElement
            case .goods:
                element = CMGoodsElement.element(collectView: collectionView, indexPath: indexPath, model: elementModel)
            case .search:
                let searchElement:CMSearchElement = CMSearchElement.element(collectionView: collectionView, indexPath: indexPath, model: elementModel)
                searchElement.delegate = self
                element = searchElement
            case .image:
                element = CMImageElement.element(collectView: collectionView, indexPath: indexPath,model: elementModel)
            case .text:
                element = CMMultlineTextElement.element(collectView: collectionView, indexPath: indexPath)
            }
        }
        
        return element
    }
    
    /// 处理布局
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    fileprivate func processHomeMallCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let item = indexPath.item
        var element:CMBaseElement?
        
        if section < layoutModels.count {
            let layout = layoutModels[section]
            let style:CMLayoutStyle = layout.layout ?? CMLayoutStyle.FlowLayout
            // 单独处理垂直线性布局
            if  style == .LinerLayout, layout.layoutDirection == .horizontal {
                let linerLayoutElement = CMHorizontalLinerLayoutElement.element(collectionView: collectionView, indexPath: indexPath,layoutModel: layout)
                linerLayoutElement.delegate = self
                element = linerLayoutElement
            } else {
                element = elementsForCollectionView(collectionView, cellForItemAt: indexPath, layoutModel: layout)
            }
            
        }
        
        return element ?? CMBaseElement.element(collectView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return processHomeMallCell(collectionView, cellForItemAt: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return layoutModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutModels[section].elements?.count ?? 0
    }
    
}


extension ViewController:UICollectionViewDelegate {
    
    fileprivate func processFirstJumpRouter() {
        switch CMRouter.getTabUrl() {
        case .home:
            if let jumpUrl = CMRouter.getSubRouter() {
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(UInt64(0.5) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                    self.processJumpUrl(jumpUrl: jumpUrl)
                }
                
                if CMRouter.isSetOldUrl() {
                    CMRouter.clearOldUrl()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(UInt64(0.5) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                        self.processJumpUrl(jumpUrl: jumpUrl)
                    }
                }
            }
        default:
            break
        }
    }
    
    fileprivate func processJumpUrl(jumpUrl:String?) {
        switch CMRouter.isUrlType(url: jumpUrl) {
        case .appUrl:
            hidesBottomBarWhenPushed = true
            let controll = UIViewController()
            navigationController?.pushViewController(controll, animated: true)
            hidesBottomBarWhenPushed = false
            
        case .h5Url:
            hidesBottomBarWhenPushed = true
            let controll = UIViewController()
 
            navigationController?.pushViewController(controll, animated: true)
            hidesBottomBarWhenPushed = false
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section < layoutModels.count {
            let layout = layoutModels[indexPath.section]
            if let elements = layout.elements, indexPath.item < elements.count {
                let element = elements[indexPath.item]
                processJumpUrl(jumpUrl: element.jumpUrl)
            }
        }
        
    }
}

extension ViewController:CMBannerElementProtocol {
    func cmbannerElement(element: CMBannerElement, didSelectItemWithModel model: CMElementModel) {
        processJumpUrl(jumpUrl: model.jumpUrl)
    }
}

extension ViewController:CMSearchElementProtocol {
    func cmsearchElement(element: CMSearchElement, didClickSearchWith model: CMElementModel?) {
        processJumpUrl(jumpUrl: model?.jumpUrl)
    }
}

extension ViewController:CMHorizontalLinerLayoutElementProtocol {
    func cmhorizontalLinerLayoutElement(element: CMHorizontalLinerLayoutElement, didSelectItemModel model: CMElementModel) {
        processJumpUrl(jumpUrl: model.jumpUrl)
    }
}

extension ViewController:UIScrollViewDelegate {
    
    fileprivate func processStopAnimationCell() {
        let cells = cardView.visibleCells
        for cell in cells {
            if cell.isKind(of: CMBannerElement.self),let element = cell as? CMBannerElement {
                if element.isDisplayedInScreen() {
                    element.stopAutoBanner()
                }
            }
        }
    }
    
    fileprivate func processStartAnimationCell() {
        let cells = cardView.visibleCells
        for cell in cells {
            if cell.isKind(of: CMBannerElement.self),let element = cell as? CMBannerElement {
                if element.isDisplayedInScreen(),!element.isAutoRun {
                    element.startAutoBanner()
                }
            }
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        processStopAnimationCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        processStartAnimationCell()
    }
}


extension ViewController:CMCardLayoutProtocol {
    
    
    // 每一种布局
    func cmcardLayout(collectionView: UICollectionView?, layoutForSection section: Int) -> CMLayoutModel? {
        if section < layoutModels.count {
            let layout = layoutModels[section]
            return cardLayout?.processLayoutWithElement(layout: layout)
        }
        
        return nil
    }
}
