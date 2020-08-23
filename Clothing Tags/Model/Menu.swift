//
//  Menu.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 23.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

class Menu{
    var nameAction : String = ""
    var imageAction : UIImage!
    init(_ name : String, _ image : UIImage) {
        nameAction = name
        imageAction = image
    }
}
