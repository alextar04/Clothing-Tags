//
//  ClothesInformation.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 11.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

class Clothes{
    var name : String? = nil
    var photoClothes : UIImageView? = nil
    var photoTag : UIImageView? = nil
    var category : String? = nil
    var tagCollection : [TagData]? = nil
    
    private static var clothes : Clothes?
    private init() {}
    
    public static func getInstance()->Clothes?{
        guard let instance = self.clothes else {
            self.clothes = Clothes()
            return self.clothes
        }
        return instance
    }
}

// CORE DATA
class TagData: Equatable{
    static func == (lhs: TagData, rhs: TagData) -> Bool {
        return lhs.descriptionTag == rhs.descriptionTag
    }
    
    var descriptionTag : String = ""
    var pictureTag : UIImage!
    init(_ name : String, _ picture : UIImage) {
        descriptionTag = name
        pictureTag = picture
    }
}
