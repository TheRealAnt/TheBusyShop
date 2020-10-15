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
    
    let fruitImageView:UIImageView = {
        let img = UIImageView(frame: .zero)
        img.backgroundColor = .lightGray
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 30
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
    
    func setupFruitImage() {
        for fruit in item {
            imageUrl = fruit.image
            barcodeDescriptionLabel.text = fruit.description
            title = "Information of \(fruit.description)"
            barcodePriceLabel.text = "Price: \(fruit.price)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupFruitImage()
        self.view.addSubview(fruitImageView)
        NSLayoutConstraint.activate([
            fruitImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            fruitImageView.widthAnchor.constraint(equalToConstant: 150),
            fruitImageView.heightAnchor.constraint(equalToConstant: 150),
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
