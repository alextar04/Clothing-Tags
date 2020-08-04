//
//  extensionsViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 04.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit

class BaseSettings{
    static func navigationBarTuning (navigationController : UINavigationController?,
                                     navigationItem : UINavigationItem,
                                     nameTop : String) {
        // Надпись по центру панели
        let labelCenterName = UILabel()
        labelCenterName.text = nameTop
        labelCenterName.backgroundColor = .clear
        labelCenterName.font = UIFont(name: "a_BosaNova", size: 18)
        labelCenterName.sizeToFit()
        navigationItem.titleView = labelCenterName
        
        // Обновление цвета кнопки назад
        navigationController?.navigationBar.tintColor = .black
        if let viewControllers = navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil
            previousVC?.title = ""
        }
    }
}

