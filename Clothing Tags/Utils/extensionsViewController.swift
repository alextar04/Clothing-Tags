//
//  extensionsViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 04.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func shadowForScreen(){
        self.view.layer.shadowColor = UIColor.gray.cgColor
        self.view.layer.shadowOpacity = 0.9
        self.view.layer.shadowOffset = CGSize.zero
        self.view.layer.shadowRadius = 6
    }
}

