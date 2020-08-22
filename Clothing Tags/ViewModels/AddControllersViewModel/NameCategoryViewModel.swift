//
//  NameCategoryViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 21.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData

class NameCategoryViewModel{
    var category = [Category]()
    
    init(){
        getCategories()
    }
    
    // Получение списка всех категорий
    func getCategories(){
        let storage = AppDelegate.appDelegateLink.storage!
        let categoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            self.category = try storage.getContext().fetch(categoryRequest)
        }catch{
            print("Неудачный запрос списка категорий!")
        }
    }
    
    func addNameAndCategoryToClothes(clothes: Clothes, nameClothes: String, categoryName: String)->Clothes{
        clothes.name = nameClothes
        if let category = getCategoryByName(name: categoryName){
            clothes.categoryExternal = category
        }else{
            let storage = AppDelegate.appDelegateLink.storage!
            let item = Category(context: storage.getContext())
            item.id = Int16(category.count)
            item.name = categoryName
            item.photo = clothes.photoClothes
            
            clothes.categoryExternal = item
        }
        return clothes
    }
    
    // Получение категории по названию
    func getCategoryByName(name: String)->Category?{
        let storage = AppDelegate.appDelegateLink.storage!
        let concreteCategoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
        concreteCategoryRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do{
            let concreteCategory = try storage.getContext().fetch(concreteCategoryRequest)
            return concreteCategory.count == 0 ? nil: concreteCategory.first
        }catch{
            print("Неудачный запрос списка категорий!")
            return nil
        }
    }
}
