//
//  MenuViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 18.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMenu()
    }
    
    // CORE DATA
    class MenuData{
        var nameAction : String = ""
        var imageAction : UIImage!
        init(_ name : String, _ image : UIImage) {
            nameAction = name
            imageAction = image
        }
    }
    
    func loadMenu(){
        
        // CORE DATA
        let recievedData : [MenuData] = [MenuData("Добавить одежду", UIImage(named: "add.png")!),
                                      MenuData("Мой гардероб", UIImage(named: "listClothes.png")!),
                                      MenuData("Напоминание постирать", UIImage(named: "allert.png")!),
                                      MenuData("Галерея бирок", UIImage(named: "tags.png")!),
                                      MenuData("О приложении", UIImage(named: "iconInApp.png")!)
                                    ]
        let viewModelData = Observable.just(recievedData)
        
        viewModelData.bind(to: tableView.rx.items){
            table, row, item in
            let cell = table.dequeueReusableCell(withIdentifier: "menuScreenCell", for: IndexPath.init(row: row, section: 0)) as! MenuScreenCell
            
            cell.imageAction.image = item.imageAction
            cell.actionLabel.text = item.nameAction
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MenuData.self).subscribe(
            onNext: {
                switch $0.nameAction{
                case "Добавить одежду":
                    AppDelegate.appDelegateLink.rootViewController.switchToAddTagScreen()
                case "Галерея бирок":
                    AppDelegate.appDelegateLink.rootViewController.switchToTagGalleryScreen()
                case "О приложении":
                    AppDelegate.appDelegateLink.rootViewController.switchToAboutApplicationScreen()
                default:
                    print("You selected: \($0.nameAction)")
                }
            }).disposed(by: disposeBag)
    }
}
