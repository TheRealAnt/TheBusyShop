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
    
    struct Cell {
        static let cartCell = "cartCell"
    }
    
    // MARK: - Properties
    var cartVCBarcodeItems = [BarcodeMeta]()
    var cartVCBarcodeItemsPrices = [BarcodeMeta]()
    
    var barcode: BarcodeMeta? {
        didSet{ setupFruitImage() }
    }
    
    let cartTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
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
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func checkoutButtonPressed() {
        let vc = OrderSummaryVC()
        vc.incomingOrder = cartVCBarcodeItems
        navigationController?.present(vc, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Add 1") {  (contextualAction, view, boolValue) in
            self.cartVCBarcodeItems[indexPath.row].itemCount += 1
            self.cartVCBarcodeItems[indexPath.row].price += self.cartVCBarcodeItemsPrices[indexPath.row].price
            self.cartTableView.reloadData()
        }
        contextItem.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [contextItem])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Remove 1") {  (contextualAction, view, boolValue) in
            self.cartVCBarcodeItems[indexPath.row].itemCount -= 1
            self.cartVCBarcodeItems[indexPath.row].price -= self.cartVCBarcodeItemsPrices[indexPath.row].price
            
            if (self.cartVCBarcodeItems[indexPath.row].itemCount == 0) {
                self.cartVCBarcodeItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            self.cartTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [contextItem])
    }
    
    func showProductDescription(item: BarcodeMeta) {
        let productVC = ProductVC()
        productVC.item.removeAll()
        productVC.item.append(item)
        navigationController?.pushViewController(productVC, animated: true)
    }
}
