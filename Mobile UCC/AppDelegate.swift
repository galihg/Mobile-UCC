//
//  AppDelegate.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 5/11/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var VC: UIViewController?
    
    //static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        
        requestNotificationAuthorization(application: application)
        
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            NSLog("[RemoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
            //TODO: Handle background notification
        }
        
        // Override point for customization after application launch.
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        /*let VC = mainStoryboard.instantiateInitialViewController()
        let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "Reset Password") as! ResetPassword*/
        /*var initialViewController: UIViewController
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
        
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 23/255, green: 41/255, blue: 83/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
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

    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult)-> Void) {
        
        let dict = userInfo["aps"] as! NSDictionary;
        let message = dict["alert"];
        
        print("%@",message!);
        
    }
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions){
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        completionHandler([.alert])
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
    }
}



extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

