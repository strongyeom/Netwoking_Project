//
//  AppDelegate.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(schemaVersion: 8) { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {
                // 추가 되었다.
            }
            
            if oldSchemaVersion < 2 {
                // 삭제 되었다
            }
            
            if oldSchemaVersion < 3 {
                // 컬럼 명 변경
                migration.renameProperty(onType: BookTable.className(), from: "bookThumbnail", to: "thumbnail")
            }
            
            if oldSchemaVersion < 4 {
                // count 추가 되었음
            }
            
            if oldSchemaVersion < 5 {
                migration.enumerateObjects(ofType: BookTable.className()) { oldObject, newObject in
                    guard let old = oldObject else { return }
                    guard let new = newObject else { return }
                    
                    new["titleSummery"] = "제목은 '\(old["bookTitle"])' 이고, 내용은 '\(old["memoText"])' 입니다."
                }
            }
            
            if oldSchemaVersion < 6 {
                migration.renameProperty(onType: BookTable.className(), from: "bookTitle", to: "bookName")
            }
            
            if oldSchemaVersion < 7 {
                // exampleCount 추가 함
            }
            
            if oldSchemaVersion < 8 {
                migration.renameProperty(onType: BookTable.className(), from: "exampleCount", to: "firstCount")
            }
            
            
            
        }
        
        
        Realm.Configuration.defaultConfiguration = config
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

