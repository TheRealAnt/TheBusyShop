//
//  Extensions.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/15.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Get the app name
extension Bundle {
    // Name of the app - title under the icon.
    var displayName: String? {
            return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}

extension String {
    //MARK:- Get current Date & Time
    func getCurrentDateAndTime() -> String {
        // get the current date and time
        let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long

        // get the date time String from the date object
        return formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
    }
    
    //MARK:- get app name /String(Bundle.main.displayName!)
    func getAppName() -> String {
        guard let appName = Bundle.main.displayName else { return "App name could not be loaded :("}
        return appName
    }
}

extension UIFont {
    //MARK:- Dynamic Fonts
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
