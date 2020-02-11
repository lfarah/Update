//
//  AppDelegate.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if ProcessInfo.processInfo.arguments.contains("UI-Testing"), let bundleName = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleName)
        }

        return true
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        let openCommand =
            UIKeyCommand(title: NSLocalizedString("Reload", comment: ""),
                         image: nil,
                         action: #selector(reloadAllPosts),
                         input: "R",
                         modifierFlags: .command,
                         propertyList: nil)
        let openMenu =
            UIMenu(title: "",
                   image: nil,
                   identifier: UIMenu.Identifier("io.lucasfarah.Update.openMenu"),
                   options: .displayInline,
                   children: [openCommand])

        builder.insertChild(openMenu, atStartOfMenu: .file)
    }
    
    @objc func reloadAllPosts() {
        RSSStore.instance.reloadAllPosts()
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

