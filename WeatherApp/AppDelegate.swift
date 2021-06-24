//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 22/06/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let sharedDefaults = UserDefaults.standard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if !sharedDefaults.bool(forKey: "firstTimeLogin") {
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "helpScreenVC") as! HelpScreenVC
            window?.rootViewController = vc
            
        } else {
            print("not logged in for first time")
            let navVc = mainStoryboard.instantiateViewController(identifier: "navVC") as! UINavigationController
            window?.rootViewController = navVc
        }
        return true
    }


}

