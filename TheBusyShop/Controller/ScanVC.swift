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

class ScanVC: UIViewController {
  
  //MARK:- Properties
  
  private lazy var scanButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemGreen
    button.setTitle("Begin Scan", for: .normal)
    button.addTarget(self, action: #selector(didTapScanButton(_:)), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureNavBar()
    setupScanButton()
  }
  
  func configureNavBar() {
    navigationController?.navigationBar.barTintColor = .yellow
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    navigationController?.navigationBar.tintColor = .white
    navigationItem.title = Controller.Scan
  }
  
  func setupScanButton() {
    view.addSubview(scanButton)
    NSLayoutConstraint.activate([
      scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      scanButton.heightAnchor.constraint(equalToConstant: 80),
      scanButton.widthAnchor.constraint(equalToConstant: 100),
      scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  func setupView() {
    let scanner = Scanner()
    self.present(scanner, animated: true, completion: nil)
  }
  
  //MARK:- Helper functions
  
  @objc func didTapScanButton(_: UIButton) {
    setupView()
  }
}
