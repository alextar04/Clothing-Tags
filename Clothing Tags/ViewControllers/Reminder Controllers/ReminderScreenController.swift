//
//  ReminderScreenController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ReminderScreenController: UIViewController {
    var nameScreen: String = ""
    let viewModel = ReminderScreenViewModel()
    @IBOutlet weak var listClothesForLaundry: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
        loadLaundryTable()
    }
    
    func loadLaundryTable(){
        if let data = viewModel.laundryClothes{
            Observable.just(data).bind(to: listClothesForLaundry.rx.items){
                table, row, item in
                    let cell = table.dequeueReusableCell(withIdentifier: "ReminderTableCell", for: IndexPath.init(row: row, section: 0)) as! ReminderTableCell
                
                cell.imageClothes.roundingImageCell(newPicture: UIImage(data: item.photoClothes!))
                cell.nameClothes.text = item.name
                cell.dateLaundry.text = item.remindWashing?.parsingForClothesScreen()
                return cell
            }
        }
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
