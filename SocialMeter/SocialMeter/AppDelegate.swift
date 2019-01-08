//
//  AppDelegate.swift
//  SocialMeter
//
//  Created by Jose Miguel S N on 07/01/2019.
//  Copyright © 2019 Jose Miguel S N. All rights reserved.
//

import UIKit

import ZIPFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static public var chatStats : ChatStats? = nil
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let fileManager = FileManager()
        let destinationDir = FileManager.SearchPathDirectory.documentDirectory
        let currentWorkingPath = NSSearchPathForDirectoriesInDomains(destinationDir,
                                                                     .userDomainMask, true)[0]
        
        var destinationURL = URL(fileURLWithPath: currentWorkingPath)
        destinationURL.appendPathComponent("unzipped")
        
        
//        let files = fileManager.urls(for: destinationDir, in: .userDomainMask)
//        for f in files{
//            do{
//                try fileManager.removeItem(at: f)
//                print("Deleted \(url)")
//            } catch{
//                print("Problem deleting file:\(error)")
//            }
//        }
        
        do {
            var isDir: ObjCBool = false;
            if (fileManager.fileExists(atPath: destinationURL.path, isDirectory: &isDir)){
                if isDir.boolValue{
                    try fileManager.removeItem(at: destinationURL)
                }
            }
            
            try fileManager.createDirectory(at: destinationURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            try fileManager.unzipItem(at: url, to: destinationURL)
            
            let files = try fileManager.contentsOfDirectory(atPath: destinationURL.path)
            let fileName = files.filter{URL(fileURLWithPath: $0).pathExtension == "txt"}[0]
            let filePath = destinationURL.appendingPathComponent(fileName)
            
            AppDelegate.chatStats = ChatStats(txtFile: filePath)
            AppDelegate.chatStats!.analyze()
            
            print(filePath)
        } catch {
            print("Extraction of ZIP archive failed with error:\(error)")
        }
        
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let file = Bundle.main.path(forResource: "_chat", ofType: "txt")
        AppDelegate.chatStats = ChatStats(txtFile: URL(fileURLWithPath: file!))
        AppDelegate.chatStats!.analyze()
        
        // Override point for customization after application launch.
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

