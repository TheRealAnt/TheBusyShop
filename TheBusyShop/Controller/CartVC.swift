//
//  CartVC.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/09/29.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

class CartVC: UIViewController {
    
    // MARK: - Properties
    var cartVCBarcodeItems = [BarcodeMeta]()
    var cartVCBarcodeItemsPrices = [BarcodeMeta]()
    
    var barcode: BarcodeMeta? {
        didSet{ setupFruitImage() }
    }
    
    //  private var codes = [BarcodeMeta]() {
    //    didSet { cartTableView.reloadData() }
    //  }
    
    struct Cell {
        static let cartCell = "cartCell"
    }
    
    let cartTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        view.backgroundColor = .white
        setupView()
        
        let checkoutButtonItem = UIBarButtonItem(title: "Checkout", style: .plain, target: self, action: #selector(checkoutButtonPressed))
        self.navigationItem.rightBarButtonItem  = checkoutButtonItem
    }
    
    @objc func checkoutButtonPressed() {
        let vc = OrderSummaryVC()
        vc.incomingOrder = cartVCBarcodeItems
        navigationController?.present(vc, animated: true, completion: nil)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Handlers
    
    func setupView() {
        cartTableView.dataSource = self
        cartTableView.delegate = self
        cartTableView.rowHeight = 100
        cartTableView.register(CartCell.self, forCellReuseIdentifier: Cell.cartCell)
        
        view.addSubview(cartTableView)
        NSLayoutConstraint.activate([
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTableView.topAnchor.constraint(equalTo: view.topAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupFruitImage() {
        guard let barcode = barcode else { return }
        
        let fruitImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        fruitImageView.layer.cornerRadius = 60 / 2
        
        guard let fruitImageUrl = URL(string: barcode.image) else { return }
        fruitImageView.sd_setImage(with: fruitImageUrl, completed: nil)
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartVCBarcodeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: Cell.cartCell) as! CartCell
        cell.code = cartVCBarcodeItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showProductDescription(item: cartVCBarcodeItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartVCBarcodeItems[indexPath.row].itemCount = cartVCBarcodeItems[indexPath.row].itemCount - 1
            cartVCBarcodeItems[indexPath.row].price = cartVCBarcodeItems[indexPath.row].price - cartVCBarcodeItemsPrices[indexPath.row].price
            
            if (cartVCBarcodeItems[indexPath.row].itemCount == 0) {
                cartVCBarcodeItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            cartVCBarcodeItems.insert(cartVCBarcodeItems[indexPath.row], at: indexPath.row)
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        cartTableView.reloadData()
        print(cartVCBarcodeItems)
    }
    
    func showProductDescription(item: BarcodeMeta) {
        let productVC = ProductVC()
        productVC.item.removeAll()
        productVC.item.append(item)
        navigationController?.pushViewController(productVC, animated: true)
    }
}
