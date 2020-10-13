//
//  Constants.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/08.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("product")
