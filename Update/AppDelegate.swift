//
//  AppDelegate.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import UIKit
import UserNotifications
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if ProcessInfo.processInfo.arguments.contains("UI-Testing"), let bundleName = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleName)
        }
        
        UNUserNotificationCenter.current().delegate = self
        registerBackgroundTasks()
        return true
    }
        
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // tell the app that we have finished processing the user’s action / response
        RSSStore.instance.shouldSelectFeedURL = response.notification.request.content.userInfo["feedURL"] as? String
        completionHandler()
    }
}

// macOS Menu
extension AppDelegate {
    override func buildMenu(with builder: UIMenuBuilder) {
        let reloadCommand =
            UIKeyCommand(title: NSLocalizedString("Reload", comment: ""),
                         image: nil,
                         action: #selector(reloadAllPosts),
                         input: "R",
                         modifierFlags: .command,
                         propertyList: nil)
        
        let settingsCommand =
            UIKeyCommand(title: NSLocalizedString("Settings", comment: ""),
                         image: nil,
                         action: #selector(openSettings),
                         input: "S",
                         modifierFlags: .command,
                         propertyList: nil)
        let openSettings =
            UIMenu(title: "",
                   image: nil,
                   identifier: UIMenu.Identifier("io.lucasfarah.Update.menu"),
                   options: .displayInline,
                   children: [reloadCommand, settingsCommand])
        
        builder.insertChild(openSettings, atStartOfMenu: .file)
    }
    
    @objc func openSettings() {
        RSSStore.instance.shouldOpenSettings = true
    }
    
    @objc func reloadAllPosts() {
        RSSStore.instance.reloadAllPosts()
    }
}

// Background app refresh
extension AppDelegate {
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "io.lucasfarah.update.fetchposts", using: DispatchQueue.global()) { task in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            print("Task expired")
        }
        print("BACKGROUND REFRESH")

        RSSStore.instance.reloadAllPosts() {
            print("RELOADED ALL POSTS")
            task.setTaskCompleted(success: true)
            self.scheduleAppRefresh()
        }
        
        scheduleAppRefresh()
        
    }
    func scheduleAppRefresh() {        
        let request = BGAppRefreshTaskRequest(identifier: "io.lucasfarah.update.fetchposts")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) // App Refresh after 1 hour.
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch let error {
            print("Could not schedule app refresh: \(error)")
        }
        
    }
    
}

