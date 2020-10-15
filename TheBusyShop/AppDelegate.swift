//
//  AppDelegate.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/09/29.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Proveded Firebase login credentials.
        let email = "techcheck@ikhokha.com"
        let password = "password"
        
        // 1. Configure Firebase.
        FirebaseApp.configure()
        
        // 2. Authenticate if current user is logged in already.
        func authenticateUser() {
            if Auth.auth().currentUser == nil {
                print("DEBUG: User is NOT logged in...")
                handleLogin()
            } else {
                print("DEBUG: User IS logged in...")
            }
        }
        
        authenticateUser()
        
        // 3. Log the user in with credentials provided.
        func handleLogin() {
            AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print("DEBUG: Error loggin in \(error.localizedDescription)")
                    return
                }
                print("DEBUG: Successful login")
            }
        }
        
        // 4. Uncomment if you want to force a user to be logged out.
        //        func logUserOut() {
        //          do {
        //            try Auth.auth().signOut()
        //          } catch let error {
        //            print("DEBUG: Failed to sin out with error \(error.localizedDescription)")
        //          }
        //        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
