//
//  AppDelegate.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.host! == "payment-return" {
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            let paymentId = queryItems?.filter({$0.name == "id"}).first
            
            // do something with payemnt id here
            
            return true
        }
        
        return false
    }
}
