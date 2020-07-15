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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /* Запуск приложения с корневого RootViewController */
        window?.rootViewController = RootViewController()
        return true
    }

    
    /* Обеспечим доступ к RootViewController */
    /* 1. Доступ к экземпляру делегата */
    /* 2. Непосредственный доступ */
    static var appDelegateLink : AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController : RootViewController{
        return window?.rootViewController as! RootViewController
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Clothing_Tags")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //...
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //...
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

