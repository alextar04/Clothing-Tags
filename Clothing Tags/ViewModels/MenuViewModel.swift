//
//  MenuViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 23.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

class MenuViewModel{
    var menu = [Menu]()
    
    init() {
        menu =  [Menu("Добавить одежду", UIImage(named: "add.png")!),
                Menu("Мой гардероб", UIImage(named: "listClothes.png")!),
                Menu("Напоминание постирать", UIImage(named: "allert.png")!),
                Menu("Галерея бирок", UIImage(named: "tags.png")!),
                Menu("О приложении", UIImage(named: "iconInApp.png")!)
        ]
    }
}
