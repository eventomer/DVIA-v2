//
//  InAppPurchaseManager.swift
//  DVIA-v2
//
//  Created by Tomer Even on 11/06/2022.
//  Copyright © 2022 HighAltitudeHacks. All rights reserved.
//

import Foundation

@objcMembers class InAppPurchaseManager: NSObject {
    public static let shared = InAppPurchaseManager()
    
    public func hasItemBeenPurchased(itemID: Int) -> Bool {
        return UserDefaults.standard.bool(forKey: "webos.products.\(itemID)")
    }
}
