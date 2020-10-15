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
  
  func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
    let email = credentials.email
    let password = credentials.password
    
//    let filename = NSUUID().uuidString
//    STORAGE_PROFILE_IMAGES.child(filename)
    
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      
      if let error = error {
        print("DEBUG: Error is \(error.localizedDescription)")
        return
      }
      
      guard (result?.user.uid) != nil else { return }
      
      let values = ["email": email,
                    "password": password]
      
      print(values)
      
    }
    
  }
  
}
