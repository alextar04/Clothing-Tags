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
    @IBOutlet weak var listClothesForLaundry: UITableView!
    
    // CORE DATA
    class ClothesDataReminder{
        var nameClothes : String = ""
        var pictureClothes : UIImage!
        var dateLaundryClothes : String = ""
        init(_ name : String, _ picture : UIImage, _ dateLaundry: String) {
            nameClothes = name
            pictureClothes = picture
            dateLaundryClothes = dateLaundry
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
        loadLaundryTable()
    }
    
    func loadLaundryTable(){
        var list = [ClothesDataReminder]()
        list = [ClothesDataReminder("Очко", UIImage(named: "add.png")!, "21.02.2020 23:00"),
            ClothesDataReminder("2 Очко", UIImage(named: "add.png")!, "21.02.2020 23:00"),
            ClothesDataReminder("3 Очко", UIImage(named: "add.png")!, "21.02.2020 23:00"),
            ClothesDataReminder("4 Очко", UIImage(named: "add.png")!, "21.02.2020 23:00"),
            ClothesDataReminder("5 Очко", UIImage(named: "add.png")!, "21.02.2020 23:00"),
            ClothesDataReminder("6 Очко", UIImage(named: "add.png")!, "21.02.2020 23:00"),
            ClothesDataReminder("7 Очко", UIImage(named: "add.png")!, "21.02.2020 23:00")
        ]
        
        let observableData = Observable.just(list)
        observableData.bind(to: listClothesForLaundry.rx.items){
            table, row, item in
                let cell = table.dequeueReusableCell(withIdentifier: "ReminderTableCell", for: IndexPath.init(row: row, section: 0)) as! ReminderTableCell
            
            cell.imageClothes.image = item.pictureClothes
            cell.nameClothes.text = item.nameClothes
            cell.dateLaundry.text = item.dateLaundryClothes
            return cell
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
