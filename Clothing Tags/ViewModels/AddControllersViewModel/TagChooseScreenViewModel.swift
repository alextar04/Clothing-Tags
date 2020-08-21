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
}
