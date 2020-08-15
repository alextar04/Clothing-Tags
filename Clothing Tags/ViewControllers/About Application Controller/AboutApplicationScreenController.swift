//
//  AboutApplicationScreenController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit

class AboutApplicationScreenController: UIViewController {
    var nameScreen: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
    }

    @IBAction func swipeDetection(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: view).x
        var endStatus : Bool? = nil
        if sender.state == .began || sender.state == .changed{
            endStatus = false
        }
        if sender.state == .ended{
            endStatus = true
        }
        AppDelegate.appDelegateLink.rootViewController.loadingMenuScreen(sourceLoading: "swipe" ,distanceSwiped: Int(transition), endStatus: endStatus)
    }
}
