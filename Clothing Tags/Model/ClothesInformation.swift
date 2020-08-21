//
//  ClothesInformation.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 11.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

class ClotheS{
    var name : String? = nil
    var photoClothes : UIImageView? = nil
    var photoTag : UIImageView? = nil
    var category : String? = nil
    var tagCollection : [Sticker]? = nil
    
    private static var clothes : ClotheS?
    private init() {}
    
    public static func getInstance()->ClotheS?{
        guard let instance = self.clothes else {
            self.clothes = ClotheS()
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
