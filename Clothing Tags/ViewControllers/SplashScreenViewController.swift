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
    }
    
    private func startingSetupSettings(){
        loadingWheel.startAnimating()
        
        // Инициализация БД
        DispatchQueue.global().async {
            AppDelegate.appDelegateLink.storage = DataStorage{
                // Совершить миграцию для первого запуска приложения
                if UserDefaults.isFirstLaunch(){
                    AppDelegate.appDelegateLink.storage?.migrationFromDB()
                }
                self.loadingWheel.stopAnimating()
                AppDelegate.appDelegateLink.rootViewController.switchToMainScreen()
            }
        }
    }
    
}
