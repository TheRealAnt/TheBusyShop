//
//  OrderSummaryVC.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/12.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import UIKit

class OrderSummaryVC: UIViewController {
    
    struct Cell {
        static let orderSummary = "orderSummary"
    }
    
    //MARK:- Properites
    
    var incomingOrder = [BarcodeMeta]()
    
    var totalItemsInCart = 0
    var totalCostOfOrder = 0.0
    
    private lazy var titleView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Order Summary"
        label.font = .preferredFont(for: .title3, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var itemCountLabel: UILabel = {
        let label = UILabel()
        //label.text = "\(totalItemsInCart)"
        label.font = .preferredFont(for: .body, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        //label.text = "R\(totalCostOfOrder)"
        label.font = .preferredFont(for: .body, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private lazy var checkOutButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.backgroundColor = UIColor.init(red: 46/255, green: 204/255, blue: 113/255, alpha: 0.8)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Checkout", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        return view
    }()
    
    var orderSummaryTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let calc = calculateTotalItemCountAndPrice()
        
        itemCountLabel.text = "x\(String(calc.0))"
        totalLabel.text = "Total: R\(String(calc.1))"

        setupView()
    }
    
    @objc func checkoutButtonTapped(_: UIButton) {
        shareRecieptButtonPressed()
    }
    
    @objc func shareRecieptButtonPressed() {
        let activityVC = UIActivityViewController(activityItems: [" \(createReciept())"], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    func calculateTotalItemCountAndPrice() -> (Int, Double) {
        
        for item in incomingOrder {
            totalItemsInCart += item.itemCount
            totalCostOfOrder += item.price
        }
        return (totalItemsInCart, totalCostOfOrder)
    }
    
    func createReciept() -> String {
        
        let appName = String().getAppName()
        let dateAndTime = String().getCurrentDateAndTime()
        
        var reciept = "Thank you for shopping with \(appName)!\n\n"
        reciept.append("Receipt for order on \(dateAndTime)\n --Order summary-- \n\n")
        
        for item in incomingOrder {
            reciept.append("x\(item.itemCount)  \(item.description) R\(item.price)\n")
        }
        
        reciept.append("\nYour total cost is R\(totalCostOfOrder)")
        return reciept
    }
    
    private func setupView() {
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        ])
        
        view.addSubview(checkOutButton)
        NSLayoutConstraint.activate([
            checkOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            checkOutButton.widthAnchor.constraint(equalToConstant: 200),
            checkOutButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        setupTableView()
    }
    
    private func setupTableView() {
        orderSummaryTableView = CartVC().cartTableView
        orderSummaryTableView.separatorStyle = .none
        orderSummaryTableView.rowHeight = 100
        orderSummaryTableView.delegate = self
        orderSummaryTableView.dataSource = self
        orderSummaryTableView.register(CartCell.self, forCellReuseIdentifier: Cell.orderSummary)
        orderSummaryTableView.allowsSelection = false
        orderSummaryTableView.tableFooterView = footerView
        
        view.addSubview(orderSummaryTableView)
        NSLayoutConstraint.activate([
            orderSummaryTableView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            orderSummaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderSummaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            orderSummaryTableView.bottomAnchor.constraint(equalTo: checkOutButton.topAnchor)
        ])
        
        footerView.addSubview(totalLabel)
        NSLayoutConstraint.activate([
            totalLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10),
        ])
        
        footerView.addSubview(itemCountLabel)
        NSLayoutConstraint.activate([
            itemCountLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            itemCountLabel.trailingAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 60)
        ])
    }
}

extension OrderSummaryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomingOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderSummaryTableView.dequeueReusableCell(withIdentifier: Cell.orderSummary) as! CartCell
        cell.code = incomingOrder[indexPath.row]
        return cell
    }
}
