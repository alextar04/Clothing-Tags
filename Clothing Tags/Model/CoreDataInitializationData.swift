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
    
    class TableDatabase {}
    
    class Sticker : TableDatabase{
        let Sticker = Table("Sticker")
        let id = Expression<Int?>("id")
        let image = Expression<SQLite.Blob>("image")
        let specification = Expression<String?>("specification")
        let category = Expression<String?>("category")
    }
    
    class Category : TableDatabase{
        let Category = Table("Category")
        let id = Expression<Int?>("id")
        let name = Expression<String?>("name")
        let photo = Expression<SQLite.Blob>("photo")
    }
    
    class Clothes: TableDatabase{
        let Clothes = Table("Clothes")
        let id = Expression<Int?>("id")
        let name = Expression<String?>("name")
        let photoClothes = Expression<SQLite.Blob>("photoClothes")
        let photoTag = Expression<SQLite.Blob>("photoTag")
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
    
    func getTableInformation(_ tablename: Tablename)->(TableDatabase, [SQLite.Row]){
        var table: SQLite.Table? = nil
        var tableDatabase: TableDatabase? = nil
        var tableResult = [SQLite.Row]()
        switch tablename {
            case .Category:
                table = Category().Category
                tableDatabase = Category()
            case .Clothes:
                table = Clothes().Clothes
                tableDatabase = Clothes()
            case .Sticker:
                table = Sticker().Sticker
                tableDatabase = Sticker()
        }
        
        do{
            for item in try connection!.prepare(table!){
                tableResult.append(item)
            }
        }catch{
            fatalError("Ошибка получения \(tablename)!")
        }
        print("Успешное получение \(tablename)!")
        return (tableDatabase!, tableResult)
    }
}
