//
//  extensionsView.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 16.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func shadowForScreen(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 6
    }
    func roundingView(){
        self.layer.cornerRadius = 10
    }
}
