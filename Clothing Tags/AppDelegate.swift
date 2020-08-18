//
//  AppDelegate.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 12.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var storage: DataStorage?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Запускать приложение из корневого RootViewController
        window?.rootViewController = RootViewController()
        // Инициализация хранилища
        storage = DataStorage()
        storage?.migrationFromDB()
        
        return true
    }
    
    /* Обеспечим доступ к RootViewController */
    /* 1. Доступ к экземпляру делегата
       2. Непосредственный доступ   */
    static var appDelegateLink : AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController : RootViewController{
        return window?.rootViewController as! RootViewController
    }

    // Доступ к БД
    var dataStorage : DataStorage{
        return storage!
    }
}

