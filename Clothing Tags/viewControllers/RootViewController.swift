//
//  RootViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    // Текущий установленный viewController
    private var currentViewController : UIViewController
    
    init(){
        // Первый контроллер - Загрузка приложения с индикатором
        self.currentViewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier:
            "SplashScreenID") as! SplashScreenViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Загрузка первого контроллера (является текущим) */
        newChildViewController(newController: self.currentViewController)
    }
    
    // Запуск дочернего контроллера
    func newChildViewController(newController : UIViewController){
        addChild(newController)
        newController.view.frame = view.bounds
        view.addSubview(newController.view)
        newController.didMove(toParent: self)
    }
    
    // Обновление текущего контроллера
    func updateRootViewController(newController : UIViewController){
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        currentViewController = newController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Переход в главное меню
    func switchToMainScreen(){
        let mainScreenController = UIStoryboard(name: "MainScreen", bundle: nil).instantiateViewController(withIdentifier: "MainScreenID") as! MainScreenViewController
        let newRootController = UINavigationController(rootViewController: mainScreenController)
        /* Анимация - вставить!!! */
        newChildViewController(newController: newRootController)
        updateRootViewController(newController: newRootController)
    }

}
