//
//  extensionsImage.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 04.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func roundingImageCell(newPicture: UIImage!){
        if newPicture != nil{
            self.image = newPicture
        }
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    func roundingRect(){
        self.layer.cornerRadius = 10
    }
}
