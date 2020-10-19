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
import SDWebImage

class CartCell: UITableViewCell {
    
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
    
    let barcodeItemCount: UILabel = {
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
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colour.ikYellow
        view.layer.cornerRadius = 8
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
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        containerView.addSubview(barcodeImageView)
        NSLayoutConstraint.activate([
            barcodeImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            barcodeImageView.widthAnchor.constraint(equalToConstant: 60),
            barcodeImageView.heightAnchor.constraint(equalToConstant: 60),
            barcodeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
        ])
        
        containerView.addSubview(barcodeDescriptionLabel)
        NSLayoutConstraint.activate([
            barcodeDescriptionLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            barcodeDescriptionLabel.leadingAnchor.constraint(equalTo: barcodeImageView.trailingAnchor, constant: 10),
        ])
        
        containerView.addSubview(barcodeItemCount)
        NSLayoutConstraint.activate([
            barcodeItemCount.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        containerView.addSubview(barcodePriceLabel)
        NSLayoutConstraint.activate([
            barcodePriceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            barcodePriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            barcodeItemCount.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 60)
        ])
    }
    
    func setup() {
        guard let code = code else { return }
        let storageRef = STORAGE.reference(withPath: code.image)
        storageRef.downloadURL { (url, error) in
            guard let url = url else { return }
            self.barcodeImageView.sd_setImage(with: url, completed: nil)
        }
        barcodeItemCount.text = String("x\(code.itemCount)")
        barcodeDescriptionLabel.text = code.description
        barcodePriceLabel.text = "R\(String(format: "%.1f", code.price))"
    }
}
