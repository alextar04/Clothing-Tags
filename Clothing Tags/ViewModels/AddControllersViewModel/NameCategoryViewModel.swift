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
}
