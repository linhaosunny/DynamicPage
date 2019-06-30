//
//  MainViewController.swift
//  DynamicPage
//
//  Created by sunshine.lee on 2019/6/26.
//  Copyright © 2019 sunshine.lee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromMock()
    }
    
    /// 加载本地json
    fileprivate func loadDataFromMock() {
        let fileName = "mainFrame"
        if let mockPath = Bundle.main.path(forResource: fileName, ofType: "json"),let mockString = try? String(contentsOfFile: mockPath) {
            let json = JSON.init(parseJSON: mockString)
            let jsonOject = json.dictionary?["data"]?.dictionaryObject
            let model:CMBarModel? = CMJsonUtil.dictionaryToModel(jsonOject, CMBarModel.self)
      
            if let tabbar_items = model?.tabbar?.items {
                for item in tabbar_items {
                    let controll = ViewController()
                    addChildViewControll(controll: controll, title: item.title ?? "", normalImage: item.icon_normal ?? "", selectedImage: item.icon_select ?? "", defaultNormalImage: "rectangle", defaultSelectedImage: "rectangle", hasNavigationBar: false)
                    
      
                }
            }
        }
    }
    
    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - controll: <#controll description#>
    ///   - title: <#title description#>
    ///   - normalImage: <#normalImage description#>
    ///   - selectedImage: <#selectedImage description#>
    private func addChildViewControll(controll:UIViewController,title:String,normalImage:String,selectedImage:String,defaultNormalImage:String,defaultSelectedImage:String,hasNavigationBar:Bool) {
        
        let tabbarItem = UITabBarItem.init(title: title, image: UIImage(named: defaultNormalImage), selectedImage: UIImage(named: defaultNormalImage))
        controll.tabBarItem = tabbarItem
        
        if let normalImageUrl = URL(string: normalImage) {
            KingfisherManager.shared.retrieveImage(with: normalImageUrl, options: [.forceRefresh], progressBlock: nil) { (image, error, type, url) in
                controll.tabBarItem.image = image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

            }
        }

//        controll.tabBarItem.imageInsets = UIEdgeInsets.init(top: 18, left: 0, bottom: 18, right: 0)


        if let selectedImageUrl = URL(string: selectedImage) {
            KingfisherManager.shared.retrieveImage(with: selectedImageUrl, options: [.forceRefresh], progressBlock: nil) { (image, error, type, url) in
                controll.tabBarItem.selectedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

            }
        }
    
        
        if  hasNavigationBar {
            let navgationControll = NavigationController()
            navgationControll.addChild(controll)
            addChild(navgationControll)
        } else {
            addChild(controll)
        }
        
    }
    
  

}


