//
//  CoreDataInitialization.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 17.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData
import SQLite

class DataStorage{
    
    // MARK: Инициализация PersistentCoordinator&Context
    lazy var persistentContainer: NSPersistentContainer = {
        var modelURL = Bundle(for: type(of: self)).url(forResource: "Clothing_Tags", withExtension: "momd")!
        modelURL.appendPathComponent("Clothing_Tags.mom")
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        
        
        let container = NSPersistentContainer(name: "Clothing_Tags", managedObjectModel: managedObjectModel!)
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
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
        // fillContents(.Sticker, database.getTableInformation(.Sticker))
        // fillContents(.Category, database.getTableInformation(.Category))
        // fillContents(.Clothes, database.getTableInformation(.Clothes))
        
        getPastedContents()
    }
    
    // Инциализация БД CoreData
    func fillContents(_ tablename: Tablename, _ contents: (CoreDataInitializationData.TableDatabase, [SQLite.Row])){
        switch tablename {
            case .Category:
                let table = contents.0 as? CoreDataInitializationData.Category
                for record in contents.1{
                    let item = Category(context: getContext())
                    item.id = Int16((record[(table?.id)!])!)
                    item.name = record[(table?.name)!]
                    item.photo = Data.fromDatatypeValue(record[(table?.photo)!])
                    saveContext()
                }
            case .Clothes:
                let table = contents.0 as? CoreDataInitializationData.Clothes
                for record in contents.1{
                    let item = Clothes(context: getContext())
                    item.id = Int16((record[(table?.id)!])!)
                    item.name = record[(table?.name)!]
                    item.photoClothes = Data.fromDatatypeValue(record[(table?.photoClothes)!])
                    item.photoTag = Data.fromDatatypeValue(record[(table?.photoTag)!])
                    item.remindWashing = nil
                    
                    // ИСПРАВИТЬ!!!
                    item.categoryId = getCategoryFromId(record[(table?.idCategory)!]!)
                    
                    // Парсинг строки с стикерами
                    let arrayStickersId = getStickersIdFromString(record[table!.idsSticker]!)
                    // Добавление стикеров
                    arrayStickersId.map{id in
                        item.stickerId?.adding(getStickerFromId(id))
                    }
                    
                    saveContext()
                }
            case .Sticker:
                let table = contents.0 as? CoreDataInitializationData.Sticker
                for record in contents.1{
                    let item = Sticker(context: getContext())
                    item.id = Int16((record[(table?.id)!])!)
                    item.image = Data.fromDatatypeValue(record[(table?.image)!])
                    item.specification = record[(table?.specification)!]
                    item.category = record[(table?.category)!]
                    saveContext()
                }
        }
    }
    
    func getPastedContents(){
        do{
            let fetchRequestCategory: NSFetchRequest<Category> = Category.fetchRequest()
            let objectsCategory = try getContext().fetch(fetchRequestCategory)
            
            let fetchRequestSticker: NSFetchRequest<Sticker> = Sticker.fetchRequest()
            let objectsSticker = try getContext().fetch(fetchRequestSticker)
            
            let fetchRequestClothes: NSFetchRequest<Clothes> = Clothes.fetchRequest()
            let objectsClothes = try getContext().fetch(fetchRequestClothes)
            
            print("Число категорий: \(objectsCategory.count)")
            print("Число стикеров: \(objectsSticker.count)")
            print("Число одежд: \(objectsClothes.count)")
        }catch{
            print("Пiймали сепара!")
        }
    }
}

enum Tablename{
    case Category, Sticker, Clothes
}
