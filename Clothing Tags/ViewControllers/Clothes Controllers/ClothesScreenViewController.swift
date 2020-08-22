//
//  ClothesScreenViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 03.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EventKit

class ClothesScreenViewController: UIViewController {
    var openFromCreationClothesScreen: Bool = false
    var idClothes: Int? = nil
    var nameScreen: String? = nil
    
    @IBOutlet weak var photoClothes: UIImageView!
    @IBOutlet weak var photoTag: UIImageView!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var vkButton: UIButton!
    @IBOutlet weak var yandexButton: UIButton!
    
    @IBOutlet weak var nameClothes: UILabel!
    
    @IBOutlet weak var remindingView: UIView!
    @IBOutlet weak var remindingViewSwitcher: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dateReminding: UILabel!
    
    @IBOutlet weak var tagsTable: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    var viewModel: ClothesScreenViewModel? = nil
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen!)
        self.viewModel = ClothesScreenViewModel(idClothes: idClothes!)
        loadClothesScreen()
    }

    
    func loadClothesScreen(){
        
        nameClothes.text = viewModel?.clothes?.name
        photoClothes.image = UIImage(data: (viewModel?.clothes?.photoClothes)!)
        photoTag.image = UIImage(data: (viewModel?.clothes?.photoTag)!)
        if viewModel?.clothes?.remindWashing == nil{
            dateReminding.text = "--:--:--"
        }
        
        // Округление кнопок для публикации в заметках соцсети
        [facebookButton, vkButton, yandexButton].map{
            $0.imageView?.roundingImageCell(newPicture: nil)
        }
        
        // Округление углов фотографий одежды и тега
        [photoClothes, photoTag].map{
            $0.roundingRect()
        }
        
        setSettingsReminderView()
        // Получение высоты таблицы
        tableHeightConstraint.constant = tagsTable.rowHeight * CGFloat((viewModel?.stickers?.count)!)
        Observable.just((viewModel?.stickers)!).bind(to: tagsTable.rx.items){
            table, row, item in
            let cell = table.dequeueReusableCell(withIdentifier: "tagDescriptionCell", for: IndexPath.init(row: row, section: 0)) as! TagDescriptionCell
        
            cell.tagImage.image = UIImage(data: item.image!)
            cell.tagDescription.text = item.specification
            return cell
        }.disposed(by: disposeBag)
    }
    
    // Настройка экрана установки напоминаний
    func setSettingsReminderView(){
        remindingView.shadowForScreen()
        remindingViewSwitcher.rx.controlEvent(.valueChanged).bind{
            // Открыть окно установки нового значения
            if self.remindingViewSwitcher.isOn{
                self.remindingView.isHidden = false
            }
            // Удаление старого значения
            else{
                self.viewModel!.deleteReminder()
                // + Удалить из БД
                self.dateReminding.text = "--:--:--"
            }
        }
        
        setupButton.rx.tap.bind{
            self.remindingView.isHidden = true
            self.remindingViewSwitcher.isOn = true
            self.viewModel!.addReminder(name: self.nameClothes.text, time: self.datePicker.date)
            // Изменения в БД
            // Установка на экране значения
            self.dateReminding.text = self.datePicker.date.parsingForClothesScreen()
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.bind{
            self.remindingView.isHidden = true
            self.remindingViewSwitcher.isOn = false
        }.disposed(by: disposeBag)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        print("Меня решили удалить!")
    }
    
    @IBAction func swipeDetection(_ sender: UIPanGestureRecognizer) {
        if !openFromCreationClothesScreen{
            return
        }
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
