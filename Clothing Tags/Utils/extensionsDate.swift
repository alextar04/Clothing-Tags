//
//  extensionsDate.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 16.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation

extension Date{
    func parsingForClothesScreen()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
