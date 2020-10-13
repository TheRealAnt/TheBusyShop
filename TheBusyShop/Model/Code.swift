//
//  Code.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/11.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation

class Code: NSObject, NSCoding {
    let desc: String
    let image: String
    let price: Double
    let uid: String
  
  required convenience init?(coder aDecoder: NSCoder) {
    guard let desc = aDecoder.decodeObject(forKey: "description") as? String else { return nil }
    guard let image = aDecoder.decodeObject(forKey: "image") as? String else { return nil }
    let price = aDecoder.decodeDouble(forKey: "price")
    guard let uid = aDecoder.decodeObject(forKey: "uid") as? String else { return nil }
      self.init( desc: desc, image: image, price: price, uid: uid)
  }
  
  init(desc: String, image: String, price: Double, uid: String) {
    self.desc = desc
    self.image = image
    self.price = price
    self.uid = uid
  }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(desc, forKey: "description")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(uid, forKey: "uid")
    }
}


