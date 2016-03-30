//
//  AppDelegate.swift
//  coaSHE Project
//
//  Created by Carolina Bonturi on 10/25/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//

import UIKit
import Parse
//import FBSDKCoreKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("X1sBT41cLMl4n9bNWJN7hKmrcMByubNFzvsIBnMB", clientKey: "Ti41rddE1SUFXtHlgOdqlLShbgpGRhXVCWbRSfR2")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {
        UserProfileDAO.persistUserInfo()
        
        if(PFUser.currentUser() != nil) {
            PFUser.logOut()
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {

        UserProfileDAO.loadUserInfo()
    }

    func applicationWillTerminate(application: UIApplication) {

        UserProfileDAO.persistUserInfo()
        
        if(PFUser.currentUser() != nil) {
            PFUser.logOut()
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        return false
    }

    


}

