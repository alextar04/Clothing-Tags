//
//  TagsCollectionViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 20.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData


class TagsCollectionViewModel{
    lazy var stickers = [[Sticker]]()
    
    init() {
        getGroupedStickers()
    }
    
    func getGroupedStickers(){
        let storage = AppDelegate.appDelegateLink.storage!
        
        // Получение всех категорий стикеров
        var categories = [String]()
        let getCategoryStickerRequest = NSFetchRequest<NSDictionary>(entityName: "Sticker")
        getCategoryStickerRequest.resultType = .dictionaryResultType
        getCategoryStickerRequest.propertiesToGroupBy = ["category"]
        getCategoryStickerRequest.propertiesToFetch = ["category"]
        getCategoryStickerRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        
        do{
            let listGroup = try storage.getContext().fetch(getCategoryStickerRequest) as? [[String: AnyObject]]
            listGroup?.map{record in
                categories.append((record.values.first as? String)!)
            }
        }catch{
            print("Неудачный запрос категорий стикеров!")
        }
        
        // Получение стикеров для каждой категории
        categories.map{
            let stickerRequest: NSFetchRequest<Sticker> = Sticker.fetchRequest()
            stickerRequest.predicate = NSPredicate(format: "category = %@", $0)
            stickerRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            
            do{
                let stickersOneCategory: [Sticker] = try storage.getContext().fetch(stickerRequest)
                stickers.append(stickersOneCategory)
            }catch{
                print("Неудачный запрос стикеров для категории \($0)!")
            }
        }
    }
}
