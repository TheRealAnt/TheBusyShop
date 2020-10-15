//
//  ProductVC.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/12.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import UIKit

class ProductVC: UIViewController {
    
    var imageUrl = ""
    
    var item = [BarcodeMeta]()
    
    var barcode: BarcodeMeta? {
        didSet{ setupFruitImage() }
    }
    
    let fruitImageView:UIImageView = {
        let img = UIImageView(frame: .zero)
        img.backgroundColor = .lightGray
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 200/2
        img.clipsToBounds = true
        return img
    }()
    
    let barcodeDescriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor =  .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let barcodePriceLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor =  .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupFruitImage() {
        let fruitItem = item[0]
        let storageRef = STORAGE.reference(withPath: fruitItem.image)
        storageRef.downloadURL { (url, error) in
            guard let url = url else { return }
            self.fruitImageView.sd_setImage(with: url, completed: nil)
        }
        barcodeDescriptionLabel.text = fruitItem.description
        barcodePriceLabel.text = "R\(String(format: "%.1f", fruitItem.price))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Details"
        view.backgroundColor = .white
        setupFruitImage()
        self.view.addSubview(fruitImageView)
        NSLayoutConstraint.activate([
            fruitImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            fruitImageView.widthAnchor.constraint(equalToConstant: 200),
            fruitImageView.heightAnchor.constraint(equalToConstant: 200),
            fruitImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(barcodeDescriptionLabel)
        NSLayoutConstraint.activate([
            barcodeDescriptionLabel.topAnchor.constraint(equalTo: fruitImageView.bottomAnchor, constant: 50),
            barcodeDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            barcodeDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        view.addSubview(barcodePriceLabel)
        NSLayoutConstraint.activate([
            barcodePriceLabel.topAnchor.constraint(equalTo: barcodeDescriptionLabel.bottomAnchor, constant: 50),
            barcodePriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            barcodePriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}
