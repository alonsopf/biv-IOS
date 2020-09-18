//
//  AppDelegate.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 4/2/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
//import GoogleCast
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {//, GCKLoggerDelegate

    var window: UIWindow?
    //private let appId = "47F2CCD4"
   // let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
   // let kDebugLoggingEnabled = true

    //var back: UIColor!
    //var front: UIColor!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    /*
        let criteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        GCKCastContext.setSharedInstanceWith(options)
        
        // Enable logger.
        GCKLogger.sharedInstance().delegate = self
 */
        /*
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        window?.clipsToBounds = true
        let rootContainerVC = (window?.rootViewController as? RootContainerViewController)
        rootContainerVC?.miniMediaControlsViewEnabled = true
*/
        
        
       /* let castStyle = GCKUIStyle.sharedInstance()
        // Set the property of the desired cast widget.
        castStyle.castViews.mediaControl.miniController.bodyTextColor = UIColor.red
        back = UIColor.init(red: 81.0/255.0, green: 78.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        front = UIColor.init(red: 26.0/255.0, green: 22.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        
        castStyle.castViews.deviceControl.deviceChooser.backgroundColor = front
        castStyle.castViews.deviceControl.deviceChooser.buttonTextColor = UIColor.white
        castStyle.castViews.deviceControl.deviceChooser.headingTextColor = UIColor.white
        castStyle.castViews.deviceControl.deviceChooser.iconTintColor = UIColor.white
        castStyle.castViews.deviceControl.connectionController.toolbar.backgroundColor = back
        castStyle.castViews.deviceControl.connectionController.toolbar.headingTextColor = UIColor.white
        castStyle.castViews.deviceControl.connectionController.navigation.backgroundColor = back
        
        // Refresh all currently visible views with the assigned styles.
        castStyle.apply()

        */
        
        
        let preferences = UserDefaults.standard
        
        
       // let rightButton  = UIButton(type: .custom)
        
        if preferences.object(forKey: "firstRun") == nil {
            preferences.set(0, forKey: "idUsuario")
            preferences.set(0, forKey: "faceID")
            preferences.set(1, forKey: "tipoCuenta")//real
            preferences.set(0.0, forKey: "disponible")
            preferences.set(0.0, forKey: "ganPer")
            preferences.set(0, forKey: "posAbiertas")
            preferences.set("0", forKey: "deboPonerAlgo")
            preferences.set("0", forKey: "t")
            preferences.set("0", forKey: "hash")
            preferences.set("0", forKey: "url")
            preferences.set(true, forKey: "firstRun")
            //perfil keys
            preferences.set("", forKey: "nombre")
            preferences.set("", forKey: "correo")
            preferences.set("", forKey: "direccion")
            preferences.set("", forKey: "celular")
            preferences.set("", forKey: "CLABE")
            preferences.set("", forKey: "RFC")
            
            preferences.synchronize()
        } else {
            
        }
        //registerForPushNotifications()
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let ver = userInfo["aps"] as! NSDictionary
        
        let alert = UIAlertController(title: "BIV", message: ver.value(forKey: "alert") as? String, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
       // let content = notification.request.content
        // Process notification content
        
        completionHandler([.alert, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        /*
        let actionIdentifier = response.actionIdentifier
        //let content = response.notification.request.content
        
        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            // Do something
             break
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            // Do something
            completionHandler()
            break
        case "com.usernotificationstutorial.reply":
          //  if let textResponse = response as? UNTextInputNotificationResponse {
               // let reply = textResponse.userText
                // Send reply message
                completionHandler()
            //}
            break
        case "com.usernotificationstutorial.delete":
            // Delete message
            completionHandler()
            break
        default:
            completionHandler()
        }
 */
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    public func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        print(token)
        let preferences = UserDefaults.standard
        
        
        let toks = preferences.string(forKey: "t") ?? ""
        
        
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        let chismoso = String(format: "https://biv.mx/saveIOS_Token_Movil?t=%@&token=%@",escapedString,token)
        
        
        guard let url = URL(string: chismoso) else {return}
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                let success = jsonArray["success"] as! Int
                if success == 1 {
                    DispatchQueue.main.async {
                        //self.cargaPerfil()
                        print("Si grabo, gracias")
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
/*
    func logMessage(_ message: String,
                    at level: GCKLoggerLevel,
                    fromFunction function: String,
                    location: String) {
        if (kDebugLoggingEnabled) {
            print(function + " - " + message)
        }
    }
  */
    
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

