//
//  AppDelegate.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        /*let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //var initialViewController: UIViewController
        //var initialViewController2: BaseViewController
        
        
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "session") != nil) //your condition if user is already logged in or not
        {
            // if already logged in then redirect to MainViewController
            let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "Home") as! ViewController
            self.window?.rootViewController = initialViewController
        }
        else
        {
            //If not logged in then show LoginViewController
            let initialViewController2 = mainStoryboard.instantiateViewController(withIdentifier: "Login Screen") as! LoginScreen
            self.window?.rootViewController = initialViewController2
        }*/
        
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0, green: 0/255, blue: 90/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
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


}

