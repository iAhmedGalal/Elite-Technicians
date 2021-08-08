//
//  AppDelegate.swift
//  crafts
//
//  Created by AL Badr  on 12/27/20.
//

import UIKit
import GooglePlaces
import Firebase
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LanguageManger.shared.defaultLanguage = .ar
                
        GMSPlacesClient.provideAPIKey("AIzaSyC9pvF65RZ-A9DnMDIOWaUva4Iy0Fupifk")
        
//        UILabel.appearance().font = UIFont(name: "tajawal_medium", size: 20)
        
        return true
    }

}

