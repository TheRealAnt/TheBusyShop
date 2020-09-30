//
//  ScanVC.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/09/29.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureNavBar()
  }
  
  func configureNavBar() {
    navigationController?.navigationBar.barTintColor = .yellow
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    navigationController?.navigationBar.tintColor = .white
    navigationItem.title = Controller.Scan
  }
}
