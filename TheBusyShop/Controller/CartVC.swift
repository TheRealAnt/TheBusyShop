//
//  CartVC.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/09/29.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation

import UIKit

class CartVC: UIViewController {
  
  // MARK: - Properties
  
  //var delegate: HomeControllerDelegate?
  
  // MARK: - Init
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    configureNavBar()
  }
  
  // MARK: - Handlers
  
  func configureNavBar() {
    navigationController?.navigationBar.barTintColor = .yellow
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    navigationController?.navigationBar.tintColor = .white
    navigationItem.title = Controller.Cart
  }
}
