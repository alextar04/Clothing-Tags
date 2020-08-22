//
//  ReminderControllerViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 22.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData

class ReminderScreenViewModel{
    var laundryClothes: [Clothes]?
    
    init() {
        laundryClothes = getLaundryClothes()
    }
    
    // Выборка одежды, которая имеет напоминания о постирке
    func getLaundryClothes()->[Clothes]?{
        let storage = AppDelegate.appDelegateLink.storage!
        let request: NSFetchRequest<Clothes> = Clothes.fetchRequest()
        
        do{
            let allClothes = try storage.getContext().fetch(request)
            var filteredClothes = [Clothes]()
            
            // Из всей одежды отберем для отображения ту, которая готовится к постирке
            allClothes.map{ oneClothes in
                if oneClothes.remindWashing != nil{
                    filteredClothes.append(oneClothes)
                }
            }
            
            return filteredClothes
        }catch{
            print("Неудачный запрос списка одежды для категории!")
            return nil
        }
    }
    
}

