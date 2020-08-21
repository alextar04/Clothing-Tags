//
//  splashScreenViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startingSetupSettings()
        // Загрузка базовой информации из БД для главной страницы
    }
    
    private func startingSetupSettings(){
        loadingWheel.startAnimating()
        
        // Инициализация хранилища
        AppDelegate.appDelegateLink.storage = DataStorage()
        // Для первого запуска приложения
        AppDelegate.appDelegateLink.storage?.migrationFromDB()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            // Будем что-то загружать из БД (скорее всего)
            self.loadingWheel.stopAnimating()
            AppDelegate.appDelegateLink.rootViewController.switchToMainScreen()
        }
    }
    
}
