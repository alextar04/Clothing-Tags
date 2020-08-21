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
            
            var a0:String = oneClothes.name!
            var a2:String = (oneClothes.categoryExternal?.name)!
            var a1 = oneClothes.stickerExternal?.count
            
            let stickers = oneClothes.stickerExternal as! Set<Sticker>
            stickers.map{ sticker in
                imagesOneClothes.append(UIImage(data: sticker.image!)!)
            }
            imagesClothes.append(imagesOneClothes)
            
        }
        return imagesClothes
    }
}
