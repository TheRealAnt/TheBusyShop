//
//  CheckOutVC.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/12.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import UIKit

class CheckOutVC: UIViewController {
    
    struct Cell {
        static let checkout = "CheckoutCell"
    }
    
    // MARK:- Properties
    
    var checkoutOrder = [BarcodeMeta]()
    var updatedCheckoutOrder = [Any]()
    
    private let checkoutTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkout"
        view.backgroundColor = .white
        setupView()
        
        let shareRecieptButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareRecieptButtonPressed))
        self.navigationItem.rightBarButtonItem  = shareRecieptButtonItem
    }
    
    @objc func shareRecieptButtonPressed() {
        let activityVC = UIActivityViewController(activityItems: [" \(createReciept())"], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    func createReciept() -> String {
        
        let appName = String().getAppName()
        let dateAndTime = String().getCurrentDateAndTime()
        
        var reciept = "Thank you for shopping with \(appName)!\n\n"
        reciept.append("Receipt for order on \(dateAndTime)\n --Order summary-- \n\n")
        
        var totalCostOfOrder = 0.0
        for item in checkoutOrder {
            reciept.append("x\(item.itemCount)  \(item.description) R\(item.price)\n")
            totalCostOfOrder = totalCostOfOrder + item.price
        }
        
        reciept.append("\nYour total cost is R\(totalCostOfOrder)")
        return reciept
    }
    
    func setupView() {
        
        checkoutTableView.dataSource = self
        checkoutTableView.delegate = self
        checkoutTableView.rowHeight = 100
        checkoutTableView.register(CartCell.self, forCellReuseIdentifier: Cell.checkout)
        
        view.addSubview(checkoutTableView)
        NSLayoutConstraint.activate([
            checkoutTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutTableView.topAnchor.constraint(equalTo: view.topAnchor),
            checkoutTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
extension CheckOutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkoutOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = checkoutTableView.dequeueReusableCell(withIdentifier: Cell.checkout) as! CartCell
        cell.code = checkoutOrder[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showProductDescription(item: checkoutOrder[indexPath.row])
    }
    
    func showProductDescription(item: BarcodeMeta) {
        let vc = ProductVC()
        vc.item.removeAll()
        vc.item.append(item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
