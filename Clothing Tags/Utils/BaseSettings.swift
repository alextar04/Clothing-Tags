//
//  BaseSettings.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 06.08.2020.
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
        
        // Иконка левого меню
        let menuButton = UIButton(type: .custom)
        menuButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuButton.setImage(UIImage(named: "menu.png"), for: .normal)

         // Открытие меню по нажатию кнопки
        /*menuButton.addTarget(navigationController, action: #selector(loadMenuFromMainScreen), for: UIControl.Event.touchUpInside)*/
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    static func updateBarTintColor(navigationController : UINavigationController){
        navigationController.navigationBar.barTintColor = UIColor(red: 232.0/255.0, green: 246.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
}
