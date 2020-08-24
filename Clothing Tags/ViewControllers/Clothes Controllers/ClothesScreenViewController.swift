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

class ClothesScreenViewController: UIViewController {
    var openFromCreationClothesScreen: Bool = false
    var idClothes: Int? = nil
    var nameScreen: String? = nil
    
    @IBOutlet weak var photoClothes: UIImageView!
    @IBOutlet weak var photoTag: UIImageView!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var vkButton: UIButton!
    @IBOutlet weak var yandexButton: UIButton!
    @IBOutlet weak var socialNetworkView: UIView!
    @IBOutlet weak var socialNetworkLogo: UIImageView!
    @IBOutlet weak var socialNetworkName: UILabel!
    @IBOutlet weak var loginUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var cancelPublishButton: UIButton!
    @IBOutlet weak var statusPublish: UILabel!
    
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
            remindingViewSwitcher.isOn = false
            dateReminding.text = "--:--:--"
        }else{
            dateReminding.text = viewModel?.clothes?.remindWashing?.parsingForClothesScreen()
            remindingViewSwitcher.isOn = true
        }
        
        // Округление кнопок для публикации в заметках соцсети
        [facebookButton, vkButton, yandexButton].map{
            $0.imageView?.roundingImageCell(newPicture: nil)
        }
        
        // Округление углов фотографий одежды и тега
        [photoClothes, photoTag].map{
            $0.roundingRect()
        }
        
        // Настройка дополнительно открывающихся окон
        setSettingsReminderView()
        setSettingsSocialNetworkView()
        
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
        remindingView.roundingView()
        
        remindingViewSwitcher.rx.controlEvent(.valueChanged).bind{
            // Открыть окно установки нового значения
            if self.remindingViewSwitcher.isOn{
                self.remindingView.isHidden = false
            }
            // Удаление старого значения
            else{
                self.viewModel!.deleteReminder()
                // Удалить из БД
                self.viewModel?.deleteReminderFromDatabase()
                // Удалить на экране
                self.dateReminding.text = "--:--:--"
            }
        }
        
        setupButton.rx.tap.bind{
            self.remindingView.isHidden = true
            self.remindingViewSwitcher.isOn = true
            self.viewModel!.addReminder(name: self.nameClothes.text, time: self.datePicker.date)
            // Установка на экране значения
            self.dateReminding.text = self.datePicker.date.parsingForClothesScreen()
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.bind{
            self.remindingView.isHidden = true
            self.remindingViewSwitcher.isOn = false
        }.disposed(by: disposeBag)
    }
    
    // Настройка подэкрана интеграции с соц. Сетями
    func setSettingsSocialNetworkView(){
        self.socialNetworkView.shadowForScreen()
        self.socialNetworkView.roundingView()
        self.socialNetworkLogo.roundingRect()
        setSettingsForHideKeyboard()
        self.passwordUser.isSecureTextEntry = true
        var subscription: Disposable?
        
        // Открытие своей разновидности подэкрана для каждой из кнопок
        let buttonArray: [UIButton] = [facebookButton, vkButton, yandexButton]
        let dialogArray: [Dialog] = [FacebookDialog(), VKDialog(), YandexDialog()]
        
        let combinationButtonDialog = Array(zip(buttonArray, dialogArray))
        combinationButtonDialog.map{ pair in
            pair.0.rx.tap.bind{
                pair.1.initDialog(socialNetworkButton: pair.0,
                                  iconSocialNetworkView: self.socialNetworkLogo,
                                  nameSocialNetworkView: self.socialNetworkName,
                                  publishButton: self.publishButton,
                                  subscription: &subscription)
                self.socialNetworkView.isHidden = false
            }.disposed(by: disposeBag)
        }
        
        // Закрытие окна при нажатии на кнопку отмены
        cancelPublishButton.rx.tap.bind{
            subscription?.dispose()
            self.socialNetworkView.isHidden = true
        }.disposed(by: disposeBag)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        viewModel?.deleteClothesFromId(idClothes!)
        AppDelegate.appDelegateLink.rootViewController.switchTo(section: .mainScreen)
    }
    
    // Настройка для скрытия клавиатуры после окончания ввода
    func setSettingsForHideKeyboard(){
        let gestureRecognizerHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.actionForHideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizerHideKeyboard)
    }
    
    @objc func actionForHideKeyboard() {
        self.view.endEditing(true)
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
