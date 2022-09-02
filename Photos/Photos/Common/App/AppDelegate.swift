//
//  AppDelegate.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/04.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let diskCache = DiskCache.default
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        diskCache.createDirectoryIfNeeded()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        diskCache.clear()
    }
}
