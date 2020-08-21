//
//  CategoryScreenViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 21.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategoryScreenViewModel{
    var clothes = [Clothes]()
    
    init(idCategory: Int){
        getStickersByIdCategory(idCategory: idCategory)
    }
    
    func getStickersByIdCategory(idCategory: Int){
        let storage = AppDelegate.appDelegateLink.storage!
        let request: NSFetchRequest<Clothes> = Clothes.fetchRequest()
        request.predicate = NSPredicate(format: "categoryExternal.id = %@", String(idCategory))
        
        do{
            self.clothes = try storage.getContext().fetch(request)
        }catch{
            print("Неудачный запрос списка одежды для категории с id = \(idCategory)!")
        }
    }
    
    func convertSetStickersToImageArray()->[[UIImage]]{
        var imagesClothes = [[UIImage]]()
        clothes.map{ oneClothes in
            var imagesOneClothes = [UIImage]()
            
            let stickersIds: [Int] = getStickersIdFromString(oneClothes.stickersId!)
            stickersIds.map{ stickerId in
                imagesOneClothes.append(UIImage(data: getStickerFromId(stickerId).image!)!)
            }
            imagesClothes.append(imagesOneClothes)
            
        }
        return imagesClothes
    }
}
