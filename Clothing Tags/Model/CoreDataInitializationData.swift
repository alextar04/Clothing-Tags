//
//  CoreDataInitializationData.swift
//  
//
//  Created by Alexey Taran on 18.08.2020.
//

import Foundation
import SQLite


/* Класс для получения данных инициализации
   приложения из сторонней БД */
class CoreDataInitializationData {
    lazy var connection: Connection? = nil
    
    class Sticker{
        let Sticker = Table("Sticker")
        let id = Expression<Int?>("id")
        let image = Expression<SQLite.Blob>("image")
        let specification = Expression<String?>("specification")
        let category = Expression<String?>("category")
    }
    
    class Category{
        let Category = Table("Category")
        let id = Expression<Int?>("id")
        let name = Expression<String?>("name")
        let photo = Expression<SQLite.Blob>("photo")
    }
    
    class Clothes{
        let Clothes = Table("Clothes")
        let id = Expression<Int?>("id")
        let name = Expression<SQLite.Blob>("name")
        let photoClothes = Expression<SQLite.Blob?>("photoClothes")
        let photoTag = Expression<SQLite.Blob?>("photoTag")
        let remindWashing = Expression<SQLite.DateFunctions?>("remindWashing")
        let idCategory = Expression<Int?>("idCategory")
        let idsSticker = Expression<String?>("idsSticker")
    }
    
    
    init() {
        do{
            let sqlPath = Bundle.main.path(forResource: "initApplicationDB.sqlite", ofType: nil)
            connection = try Connection(sqlPath!)
            print("Успешное подключение")
        } catch{
            fatalError("Ошибка подключения к БД!")
        }
    }
    
    func getStickers(){
        
    }
    
    func getCategories(){
        
    }
    
    func getClothes(){
        
    }
    
}
