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
