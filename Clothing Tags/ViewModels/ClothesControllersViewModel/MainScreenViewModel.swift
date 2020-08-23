//
//  MainScreenViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 21.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData

class MainScreenViewModel{
    var categories = [Category]()
    
    init(){
        let categoryViewModel = NameCategoryViewModel()
        categories = categoryViewModel.category

            let othersCategoryIndex: Int? = categories.firstIndex(where: { category in
                return category.name == "(Прочее)"
            })
        
        guard let otherIndex = othersCategoryIndex else{
            fatalError("Категория 'Прочее' не найдена!")
        }
        categories.remove(at: otherIndex)
        
        /**************/
        let request: NSFetchRequest<Clothes> = Clothes.fetchRequest()
        var clothesList = [Clothes]()
        do{
            let clothesAllList = try AppDelegate.appDelegateLink.storage!.getContext().fetch(request)
            for item in clothesAllList{
                print(item.wrapperEvent?.event)
            }
        }catch{
            print("__")
        }
        
    }
}
