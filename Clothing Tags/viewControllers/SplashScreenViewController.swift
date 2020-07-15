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
    override func viewDidLoad() {
        super.viewDidLoad()
        startingSetup()
        // Загрузка базовой информации из БД для главной страницы
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    private func startingSetup(){
        loadingWheel.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            print("Синхронизация!")
            self.loadingWheel.stopAnimating()
            AppDelegate.appDelegateLink.rootViewController.switchToMainScreen()
        }
    }
    
}
