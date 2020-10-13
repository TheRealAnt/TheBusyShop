//
//  CartCell.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/07.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CartCell: UITableViewCell {
  let scanner = ScannerVC()
  
  var code: BarcodeMeta? {
    didSet { setup() }
  }
  
  let barcodeImageView:UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFill
    img.translatesAutoresizingMaskIntoConstraints = false
    img.layer.cornerRadius = 30
    img.clipsToBounds = true
    return img
  }()
  
  let barcodeDescriptionLabel:UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textColor =  .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let barcodePriceLabel:UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textColor =  .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let containerView:UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = true
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(barcode: test) {
    barcodeImageView.image = barcode.image
    barcodeDescriptionLabel.text = barcode.description
    barcodePriceLabel.text = String(format: "%.1f", barcode.price)
  }
  
  func setupCell() {
    addSubview(barcodeImageView)
    NSLayoutConstraint.activate([
      barcodeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      barcodeImageView.widthAnchor.constraint(equalToConstant: 60),
      barcodeImageView.heightAnchor.constraint(equalToConstant: 60),
      barcodeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
    ])
    
    addSubview(barcodePriceLabel)
    NSLayoutConstraint.activate([
      barcodePriceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      barcodePriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
    ])
    
    addSubview(barcodeDescriptionLabel)
    NSLayoutConstraint.activate([
      barcodeDescriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      barcodeDescriptionLabel.leadingAnchor.constraint(equalTo: barcodeImageView.trailingAnchor, constant: 10),
    ])
  }
  
  func setup() {
    guard let code = code else { return }
    
    let ref = STORAGE_REF.storage.reference(forURL: "gs://the-busy-shop.appspot.com/\(code.image)")
    
    ref.downloadURL { (url, error) in
      let data = NSData(contentsOf: url!)
      let image = UIImage(data: data! as Data)
      self.barcodeImageView.image = image
    }
    barcodeDescriptionLabel.text = code.description
    barcodePriceLabel.text = String(format: "%.1f", code.price)
  }
}
