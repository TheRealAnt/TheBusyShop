//
//  Barcodes.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/03.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import UIKit

struct test {
  let description: String
  let image: UIImage
  let price: Double
}

struct Barcode {
  let APL883: String
  let BAN258: String
  let COC378: String
  let GPF208: String
  let ORN750: String
  let PER478: String
  let SBR101: String
  let WML999: String
}

struct BarcodeMeta: Hashable {
  let description: String
  let image: String
  var price: Double
  let uid: String
  var itemCount: Int
  
  init(uid: String, itemCount: Int, dictionary: [String: AnyObject]) {
    self.uid = uid
    self.itemCount = dictionary["itemCount"] as? Int ?? 0
    self.description = dictionary["description"] as? String ?? ""
    self.image = dictionary["image"] as? String ?? ""
    self.price = dictionary["price"] as? Double ?? 0.0
  }
}
