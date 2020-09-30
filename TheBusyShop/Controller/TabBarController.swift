//
//  TabBarController.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/09/29.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
 
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.tabBar.barTintColor = .yellow
    self.tabBar.tintColor = .black
    self.tabBar.isTranslucent = false
    let viewControllers = [scanTabBarItem, cartTabBarItem]
    self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0)}
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK:- Scan

  lazy public var scanTabBarItem: ScanVC = {
    let scanTabBarItem = ScanVC()
    scanTabBarItem.tabBarItem = UITabBarItem(title: Controller.Scan, image: Image.Scan, selectedImage: Image.Scan)
    return scanTabBarItem
  }()

  //MARK:- Cart

  lazy public var cartTabBarItem: CartVC = {
    let cartTabBarItem = CartVC()
    cartTabBarItem.tabBarItem = UITabBarItem(title: Controller.Cart, image: Image.Cart, selectedImage: Image.Cart)
    return cartTabBarItem
  }()
}
