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
    override var childForStatusBarHidden: UIViewController? {
        return children.last
    }
    
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
        newChildViewController(newController: self.currentViewController, animationClosure: nil)
    }
    
    // Установка контроллера
    func newChildViewController(newController : UIViewController, animationClosure : (()->Void)?){
        addChild(newController)
        setNeedsStatusBarAppearanceUpdate()
        newController.view.frame = view.bounds
        animationClosure != nil ? animationClosure!() : view.addSubview(newController.view)
        newController.didMove(toParent: self)
    }
    
    // Обновление текущего контроллера
    func updateRootViewController(newController : UIViewController){
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        currentViewController = newController
    }
    
    // Переход в главное меню
    func switchToMainScreen(){
        let mainScreenController = UIStoryboard(name: "MainScreen", bundle: nil).instantiateViewController(withIdentifier: "MainScreenID") as! MainScreenViewController
        let newRootController = UINavigationController(rootViewController: mainScreenController)

        newChildViewController(newController: newRootController, animationClosure: { UIView.transition(with: self.view, duration: 0.5, options: [.transitionFlipFromRight, .allowAnimatedContent], animations: {self.view.addSubview(newRootController.view)},
            completion: nil)}
        )
        
        updateRootViewController(newController: newRootController)
    }
    
    func loadingLeftMenu(){
        let menuViewController = UIStoryboard(name: "MenuScreen", bundle: nil).instantiateViewController(withIdentifier: "MenuScreenID") as? MenuViewController
        addChild(menuViewController!)
        view.insertSubview(menuViewController!.view, at: 0)
        print("Добавили menuController")
        }

}
