//
//  MainScreenViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift

class MainScreenViewController: UIViewController {
    
    var menuViewController : MenuViewController!
    var needShowMenu : Bool = false
    override var prefersStatusBarHidden: Bool {
         return false
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarTuning()
        loadMainMenu()
    }
    
    
    func navigationBarTuning(){
        // Цвет панели
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // Надпись по центру панели
        let labelCenterName = UILabel()
        labelCenterName.text = "Бирки одежды"
        labelCenterName.backgroundColor = .clear
        labelCenterName.font = UIFont(name: "a_BosaNova", size: 18)
        labelCenterName.sizeToFit()
        navigationItem.titleView = labelCenterName
        
        // Иконка левого меню (а также со свайпом)
        let menuButton = UIButton(type: .custom)
        menuButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuButton.setImage(UIImage(named: "menu.png"), for: .normal)
        menuButton.addTarget(self, action: #selector(loadMenuFromMainScreen), for: UIControl.Event.touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.leftBarButtonItem = menuBarItem
        
        //navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    func loadMainMenu(){
        
    }
    
    // MARK: Обработка действий с левым боковым меню
    
    @objc func loadMenuFromMainScreen(){
        AppDelegate.appDelegateLink.rootViewController.loadingLeftMenu()
        needShowMenu = !needShowMenu
        switcherMenuViewController(needShowMenu: needShowMenu)
    }
    
    func switcherMenuViewController(needShowMenu: Bool){
        if needShowMenu{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { self.view.frame.origin.x =
                            self.view.frame.width - 140 },
                           completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: { self.view.frame.origin.x = 0},
            completion: nil)
        }
    }
    
}
