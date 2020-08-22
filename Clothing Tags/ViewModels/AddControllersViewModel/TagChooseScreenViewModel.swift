//
//  TagChooseScreenViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 21.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData

class TagChooseScreenViewModel{
    var stickers = [[Sticker]]()
    var listSelectedIndexStickers = [IndexPath]()
    var listSelectedStickers = [Sticker]()
    
    init(){
        // Импорт данных о стикерах
        let collectionStickersViewModel = TagsCollectionViewModel()
        stickers = collectionStickersViewModel.stickers
    }
    
    func addIdsStickersToClothes(clothes: Clothes)->Clothes{
        var stickerIdsList = [String]()
        listSelectedStickers.map{
            stickerIdsList.append(String($0.id))
        }
        clothes.stickersId = stickerIdsList.joined(separator: ",")
        return clothes
    }
    
    func addOtherParametrsAndSave(clothes: Clothes){
        let storage = AppDelegate.appDelegateLink.storage!
        do{
            // Найдем последний существующий id-одежды для вставки нового
            let fetchRequestClothes: NSFetchRequest<Clothes> = Clothes.fetchRequest()
            let objectsClothes = try AppDelegate.appDelegateLink.storage!.getContext().fetch(fetchRequestClothes)
            
            clothes.id = Int16(objectsClothes.count)
            clothes.remindWashing = nil
            //clothes.eventObject = nil
            //clothes.event = nil
            storage.saveContext()
        }catch{
            print("Неудачный запрос одежды!")
        }
        
    }
    
}
