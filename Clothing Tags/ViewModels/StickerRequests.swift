//
//  StickerRequests.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 17.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData

class StickerRequests{
    static func getAllStickers()->[Sticker]?{
        let storage = AppDelegate.appDelegateLink.dataStorage
        let getAllStickersRequest: NSFetchRequest<Sticker> = Sticker.fetchRequest()
        do{
            let result = try storage.getContext().fetch(getAllStickersRequest)
            return result
        }catch{
            print("Неудачный запрос стикеров!")
        }
        return nil
    }
}

func getStickerFromId(_ id: Int)->Sticker{
    let request: NSFetchRequest<Sticker> = Sticker.fetchRequest()
    request.predicate = NSPredicate(format: "id = %@", String(id))
    do{
        let sticker = try AppDelegate.appDelegateLink.dataStorage.getContext().fetch(request)
        return sticker.first!
    } catch{
        fatalError("Ошибка получения стикера по Id!")
    }
}
