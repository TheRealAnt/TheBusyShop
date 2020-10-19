//
//  Constants.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/08.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Firebase

let STORAGE = Storage.storage()
let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("product")

//MARK:- iKhokha colors

struct Colour {
   static let ikYellow = UIColor(hexString: "#ffc533")
}

//MARK:- Images

struct Image {
    static let Scan = UIImage(named: "scan") ?? UIImage()
    static let Cart = UIImage(named: "cart") ?? UIImage()
}
