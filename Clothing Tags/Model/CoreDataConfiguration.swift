//
//  CoreDataInitialization.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 17.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData

class DataStorage{
    
    // MARK: Инициализация PersistentCoordinator&Context
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Clothing_Tags")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Возврат контекста, содержащего все сущности
    func getContext()->NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Миграция из сторонней БД для инциализации хранилища приложения
    func migrationFromDB(){
        let database = CoreDataInitializationData()
        //fillStickers(database.getStickers())
        //fillCategories(database.getCategories())
        //fillClothes(database.getClothes())
    }
}
