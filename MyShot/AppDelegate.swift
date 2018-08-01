//
//  AppDelegate.swift
//  MyShot
//
//  Created by Administrador on 17/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import HexColors
import IQKeyboardManagerSwift
import FirebaseCore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Firebase delegate
        FIRApp.configure()
        
        //Facebook delegate
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        UserSingleton.shared.facebookSignOut()
        let loginView : FBSDKLoginManager = FBSDKLoginManager()
        loginView.loginBehavior = FBSDKLoginBehavior.web
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = Constants.GOOGLE_CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()
        //Status Bar
        UIApplication.shared.statusBarView?.backgroundColor = HexColor(Colors.mainColor)
        UINavigationBar.appearance().barTintColor = HexColor(Colors.mainColor)
        UINavigationBar.appearance().isTranslucent = false
        
        //Delegating IQKeyboard
        IQKeyboardManager.sharedManager().enable = true
        
        //Calling Lottie
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "lauchController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }
    //Instance
    class func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - Facebook/Google handler
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication =  options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        let googleHandler = GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application (
            app,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        return googleHandler || facebookHandler
    }
   
    // MARK: - Google Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        defaults.removeObject(forKey: "cellMenu")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        defaults.removeObject(forKey: "cellMenu")
    }

    func applicationWillTerminate(_ application: UIApplication) {
       defaults.removeObject(forKey: "cellMenu")
    }
  
    
}

