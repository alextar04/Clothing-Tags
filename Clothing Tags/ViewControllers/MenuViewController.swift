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
    let viewModel = MenuViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMenu()
    }
    
    func loadMenu(){
        
        Observable.just(viewModel.menu).bind(to: tableView.rx.items){
            table, row, item in
            let cell = table.dequeueReusableCell(withIdentifier: "menuScreenCell", for: IndexPath.init(row: row, section: 0)) as! MenuScreenCell
            
            cell.imageAction.image = item.imageAction
            cell.actionLabel.text = item.nameAction
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Menu.self).subscribe(
            onNext: {
                switch $0.nameAction{
                case "Добавить одежду":
                    AppDelegate.appDelegateLink.rootViewController.switchTo(section: .addTagScreen)
                case "Мой гардероб":
                    AppDelegate.appDelegateLink.rootViewController.switchTo(section: .mainScreen)
                case "Напоминание постирать":
                    AppDelegate.appDelegateLink.rootViewController.switchTo(section: .reminderScreen)
                case "Галерея бирок":
                    AppDelegate.appDelegateLink.rootViewController.switchTo(section: .tagGalleryScreen)
                case "О приложении":
                    AppDelegate.appDelegateLink.rootViewController.switchTo(section: .aboutApplicationScreen)
                default:
                    print("You selected: \($0.nameAction)")
                }
            }).disposed(by: disposeBag)
    }
}
