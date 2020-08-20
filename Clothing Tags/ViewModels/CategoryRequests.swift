//
//  CategoryRequests.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 19.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData

func getCategoryFromId(_ id: Int)->Category{
    let request: NSFetchRequest<Category> = Category.fetchRequest()
    request.predicate = NSPredicate(format: "id = %@", String(id))
    do{
        let category = try AppDelegate.appDelegateLink.dataStorage.getContext().fetch(request)
        return category.first!
    } catch{
        fatalError("Ошибка получения категории по Id!")
    }
}


