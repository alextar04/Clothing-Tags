//
//  RootViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    // MARK: Текущий установленный viewController
    private var currentViewController : UIViewController
    override var childForStatusBarHidden: UIViewController? {
        return children.last
    }
    
    init(){
        // MARK: Первый контроллер - Загрузка приложения с индикатором
        self.currentViewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier:
            "SplashScreenID") as! SplashScreenViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* MARK: Загрузка первого контроллера (является текущим) */
        newChildViewController(newController: self.currentViewController, animationClosure: nil)
    }
    
    // MARK: Установка контроллера
    func newChildViewController(newController : UIViewController, animationClosure : (()->Void)?){
        addChild(newController)
        setNeedsStatusBarAppearanceUpdate()
        newController.view.frame = view.bounds
        animationClosure != nil ? animationClosure!() : view.addSubview(newController.view)
        newController.didMove(toParent: self)
    }
    
    // MARK: Обновление текущего контроллера
    func updateRootViewController(newController : UIViewController){
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        currentViewController = newController
    }
    
    // MARK: Переход в главный экран
    func switchToMainScreen(){
        
        let mainScreenController = UIStoryboard(name: "MainScreen", bundle: nil).instantiateViewController(withIdentifier: "MainScreenID") as! MainScreenViewController
        let newRootController = UINavigationController(rootViewController: mainScreenController)

        newChildViewController(newController: newRootController, animationClosure: { UIView.transition(with: self.view, duration: 0.5, options: [.transitionFlipFromRight, .allowAnimatedContent], animations: {self.view.addSubview(newRootController.view)},
            completion: nil)}
        )
        updateRootViewController(newController: newRootController)
    }
    
    // MARK: Переход в меню приложения
    var menuViewController : MenuViewController!
    var needShowMenu : Bool = false
    func loadingMenuScreen(sourceLoading : String, distanceSwiped : Int, endStatus: Bool?){
        var offsetRootView = distanceSwiped
        if menuViewController == nil{
            menuViewController = UIStoryboard(name: "MenuScreen", bundle: nil).instantiateViewController(withIdentifier: "MenuScreenID") as? MenuViewController
            view.insertSubview(menuViewController!.view, at: 0)
            addChild(menuViewController!)
            print("Добавлен menuController")
        }
        
        switch sourceLoading {
            // Для обработки открытия меню по нажатию на кнопку
        case "barButton":
            needShowMenu = !needShowMenu
            // Для обработки открытия меню при свайпе
        case "swipe":
            needShowMenu = true
            let windowPosition = Int(self.currentViewController.view.frame.origin.x)
            // Нажатие не окончено
            if !endStatus!{
                if offsetRootView >= 0{
                    // Максимум: 240
                    if offsetRootView > 240 || windowPosition == 240{
                        offsetRootView = 240
                    }
                    break
                }
                if offsetRootView < 0{
                    // Минимум: 0
                    offsetRootView = 240 + offsetRootView
                    if offsetRootView < 0 || windowPosition == 0{
                        offsetRootView = 0
                    }
                    break
                }
            }
            // Нажатие окончено
            if endStatus!{
                if offsetRootView > 0{
                    if windowPosition < 240{
                        offsetRootView = offsetRootView > 10 ? 240 : 0
                    }else{
                        offsetRootView = 240
                    }
                    break
                }
                if offsetRootView <= 0{
                    if windowPosition > 0{
                        offsetRootView = offsetRootView < -10 ? 0 : 240
                    }else{
                        offsetRootView = 0
                    }
                    break
                }
            }
        default:
            fatalError()
        }
        if sourceLoading == "swipe"{
            needShowMenu = offsetRootView == 0 ? false : true
        }
        
        switcherMenuViewController(needShowMenu: needShowMenu, distanceSwiped: offsetRootView)
        
        // MARK: Тень на окно при открытии меню
        self.currentViewController.view.layer.shadowColor = UIColor.gray.cgColor
        self.currentViewController.view.layer.shadowOpacity = 0.9
        self.currentViewController.view.layer.shadowOffset = CGSize.zero
        self.currentViewController.view.layer.shadowRadius = 6
        
        
    }
    
    func switcherMenuViewController(needShowMenu: Bool, distanceSwiped : Int){
        if needShowMenu{
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.currentViewController.view.frame.origin.x =
                            CGFloat(distanceSwiped)
            },
                           completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: { self.currentViewController.view.frame.origin.x = 0},
            completion: nil)
        }
    }
    
    
}


