//
//  AppDelegate.swift
//  DVIA - Damn Vulnerable iOS App (damnvulnerableiosapp.com)
//  Created by Prateek Gianchandani on 22/11/17.
//  Copyright © 2018 HighAltitudeHacks. All rights reserved.
//  You are free to use this app for commercial or non-commercial purposes
//  You are also allowed to use this in trainings
//  However, if you benefit from this project and want to make a contribution, please consider making a donation to The Juniper Fund (www.thejuniperfund.org/)
//  The Juniper fund is focusing on Nepali workers involved with climbing and expedition support in the high mountains of Nepal. When a high altitude worker has an accident (death or debilitating injury), the impact to the family is devastating. The juniper fund provides funds to the affected families with a 3-Tier model - Cost of Living grant, vocational training and small business grant.
//  For more information,  visit www.thejuniperfund.org
//  Or watch this video https://www.youtube.com/watch?v=HsV6jaA5J2I
//  And this https://www.youtube.com/watch?v=6dHXcoF590E
 

import UIKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(red: 0.9, green: 0.13, blue: 0.28, alpha: 1.0)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white , NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 20)!]
        navigationBarAppearace.titleTextAttributes = textAttributes
        
        printLogs()
        return true
    }
    
    private func printLogs() {
        let user = LoginUserInput(
            name: "tomer",
            password: "secret-password",
            phone: "0501234567",
            email: "tomer@example.com"
        )
        if let jsonData = try? JSONEncoder().encode(user), let jsonString = String(data: jsonData, encoding: .utf8) {
            os_log("Current user info: %@", jsonString)
        }
        
        let isPremiumUser = UserDefaults.standard.bool(forKey: "isPremiumUser")
        os_log("isPremiumUser: \(isPremiumUser)")
        
        os_log("did unlock product1? \(InAppPurchaseManager.shared.hasItemBeenPurchased(itemID: 1))")
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
        if url.absoluteString.contains("phone/call_number") {
            //Valid URL, since the argument is a number
            let alertController = UIAlertController(title: "Success!", message: "Calling \(url.lastPathComponent). Ring Ring !!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(okAction)
            window?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else if url.absoluteString.contains("secret-developer-mode") {
            let alertController = UIAlertController(title: "Developer Mode!", message: "You are now under developer mode", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(okAction)
            window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func showHome() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboard.home.name, bundle: nil)
        var vc: UIViewController?
        vc = mainStoryboard.instantiateInitialViewController()
        self.window?.rootViewController = vc
    }

}

