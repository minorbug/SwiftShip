//
//  AppDelegate.swift
//  SwiftShip
//
//  Created by Matt Baker on 10/13/14.
//  Copyright (c) 2014 Matt Baker. All rights reserved.
//

import UIKit
import AirshipKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Display a UIAlertView warning developers that push notifications do not work in the simulator
        // You should remove this in your app.
        failIfSimulator()
        
        // Set log level for debugging config loading (optional)
        // It will be set to the value in the loaded config upon takeOff
        UAirship.setLogLevel(UALogLevel.Trace)
        
        // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
        // or set runtime properties here.
        var config:UAConfig = UAConfig.defaultConfig()
        
        // You can then programmatically override the plist values:
        // config.developmentAppKey = "YourKey";
        // etc.
        
        // Call takeOff (which creates the UAirship singleton)
        UAirship.takeOff(config)
        
        // Print out the application configuration for debugging (optional)
        println("Config: \(config.description)");
        
        // Set the icon badge to zero on startup (optional)
        UAPush.shared().resetBadge()
        
        // Set the notification types required for the app (optional). This value defaults
        // to badge, alert and sound, so it's only necessary to set it if you want
        // to add or remove types.
        UAPush.shared().userNotificationTypes = (UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound)
        
        // User notifications will not be enabled until userPushNotificationsEnabled is
        // set "true" on UAPush. Once enabled, the setting will be persisted and the user
        // will be prompted to allow notifications. You should wait for a more appropriate
        // time to enable push to increase the likelihood that the user will accept
        // notifications.
        UAPush.shared().userPushNotificationsEnabled = true
        
        
        
        return true
    }

    func failIfSimulator(){
        if (UIDevice.currentDevice().model.rangeOfString("Simulator") != nil){
            let alert = UIAlertView()
            alert.title     = "Notice"
            alert.message   = "You will not be able to receive push notifications in the simulator."
            alert.addButtonWithTitle("OK")
            
            // Let the UI finish launching first so it doesn't complain about the lack of a root view controller
            // Delay execution of the block for 1/2 second.
            
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue())
                {
                    alert.show()
                }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    
    func applicationDidBecomeActive(application: UIApplication) {
        println("Application did become active.")
        
        // Set the icon badge to zero on resume (optional)
        UAPush.shared().resetBadge()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo:NSDictionary) {
        println("Received remote notification (in appDelegate): \(userInfo)")
        // Optionally provide a delegate that will be used to handle notifications received while the app is running
        // UAPush.shared().pushNotificationDelegate = your custom push delegate class conforming to the UAPushNotificationDelegate protocol

        // Reset the badge after a push received (optional)
        UAPush.shared().resetBadge()
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: NSDictionary, fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            println("Received remote notification (in appDelegate): \(userInfo)")
            // Optionally provide a delegate that will be used to handle notifications received while the app is running
            // UAPush.shared().pushNotificationDelegate = your custom push delegate class conforming to the UAPushNotificationDelegate protocol
            
            // Reset the badge after a push received (optional)
        
            if (application.applicationState != UIApplicationState.Background){
                UAPush.shared().resetBadge()
            }
        }
    

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

