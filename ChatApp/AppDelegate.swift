//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 21/01/22.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import GoogleMaps
import GooglePlaces
import FirebaseCrashlytics
import IQKeyboardManager
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        ///initialise facebook
        FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        ///google
        GMSServices.provideAPIKey("AIzaSyDIgN5-EiFsLEojuoxzkKbsJp6ayZnIONA")
        GMSPlacesClient.provideAPIKey("AIzaSyDIgN5-EiFsLEojuoxzkKbsJp6ayZnIONA")
        checkUser()
            return true
        
    }
    
    //check user is avialable or not
    func checkUser(){
      
    }
  


}

