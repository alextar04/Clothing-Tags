//
//  SocialNetwork.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 22.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

class SocialNetwork{
    var listLogos = [UIImage]()
    
    init() {
        let nameSocialNetworks = ["facebook", "vk", "yandex"]
        nameSocialNetworks.map{
            listLogos.append(UIImage(named: "\($0)Logo.png")!)
        }
    }
}
