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
    override var prefersStatusBarHidden: Bool {
         return false
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTuning()
        loadMainMenu()
    }
    
    
    func navigationBarTuning(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let labelCenterName = UILabel()
        labelCenterName.text = "Бирки одежды"
        labelCenterName.backgroundColor = .clear
        labelCenterName.font = UIFont(name: "a_BosaNova", size: 18)
        labelCenterName.sizeToFit()
        navigationItem.titleView = labelCenterName
        
        //navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func loadMainMenu(){
        /*let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: Selector(("btnOpenCamera")))
        self.navigationItem.rightBarButtonItem  = camera*/
        let food = Observable.just(["Ada", "Boost"])
    }
}
