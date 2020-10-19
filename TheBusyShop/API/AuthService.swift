//
//  AuthService.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/08.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
}
