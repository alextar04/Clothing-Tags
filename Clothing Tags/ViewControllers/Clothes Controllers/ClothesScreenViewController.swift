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
    
    @IBOutlet weak var photoClothes: UIImageView!
    @IBOutlet weak var photoTag: UIImageView!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var vkButton: UIButton!
    @IBOutlet weak var yandexButton: UIButton!
    
    @IBOutlet weak var nameClothes: UILabel!
    
    @IBOutlet weak var remindingView: UIView!
    var eventObject: EKEventStore? = nil
    var event: EKEvent? = nil
    @IBOutlet weak var remindingViewSwitcher: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dateReminding: UILabel!
    
    @IBOutlet weak var tagsTable: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    
    // Предварительно
    // CORE DATA
    var recievedData : [TagData] = [
        TagData("Полоскайте белье под температурой 30 градусов на бережной стирке", UIImage(named: "tags.png")!),
        TagData("Теннисные носки", UIImage(named: "facebookLogo.png")!),
        TagData("Теннисные носки", UIImage(named: "sticker1_1.png")!),
        TagData("Теннисные носки", UIImage(named: "tags.png")!),
        TagData("Теннисные носки", UIImage(named: "tags.png")!),
    ]
    var photoClothesData: UIImageView!
    var photoTagData: UIImageView!
    var nameClothesData: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: "Одежда")
        loadClothesScreen()
    }

    
    func loadClothesScreen(){
        
        //  Предварительно
        if photoClothesData == nil{
            photoClothes.image = UIImage(named: "facebookLogo.png")!
            photoTag.image = UIImage(named: "facebookLogo.png")!
        }else{
            photoClothes.image = photoClothesData.image
            photoTag.image = photoTagData.image
            nameClothes.text = nameClothesData.text
        }
        
        // Округление кнопок для публикации в заметках соцсети
        [facebookButton, vkButton, yandexButton].map{
            $0!.imageView?.roundingImageCell(newPicture: nil)
        }
        // Округление углов фотографий одежды и тега
        [photoClothes, photoTag].map{
            $0.roundingRect()
        }
        
        setSettingsReminderView()
        
        // Получение высоты таблицы
        tableHeightConstraint.constant = tagsTable.rowHeight * CGFloat(recievedData.count)
        let viewModelData = Observable.just(recievedData)
        viewModelData.bind(to: tagsTable.rx.items){
            table, row, item in
            let cell = table.dequeueReusableCell(withIdentifier: "tagDescriptionCell", for: IndexPath.init(row: row, section: 0)) as! TagDescriptionCell
        
            cell.tagImage.image = item.pictureTag
            cell.tagDescription.text = item.descriptionTag
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
                self.deleteReminder()
                // + Удалить из БД
                self.dateReminding.text = "--:--:--"
            }
        }
        
        setupButton.rx.tap.bind{
            self.remindingView.isHidden = true
            self.remindingViewSwitcher.isOn = true
            self.addReminder()
            // Изменения в БД
            // Установка на экране значения
            self.dateReminding.text = self.datePicker.date.parsingForClothesScreen()
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.bind{
            self.remindingView.isHidden = true
            self.remindingViewSwitcher.isOn = false
        }.disposed(by: disposeBag)
    }
    
    func addReminder(){
            eventObject = EKEventStore()
            eventObject!.requestAccess(to: .event){ granted, error in
                let newEvent = EKEvent(eventStore: self.eventObject!)
                newEvent.title = self.nameClothes.text
                newEvent.notes = "Необходимо постирать!"

                let updatedDate = self.datePicker.date.zeroingSecondsInAlarmForReminders()
                print(updatedDate)
                newEvent.startDate = updatedDate
                newEvent.endDate = updatedDate
                newEvent.addAlarm(EKAlarm(absoluteDate: updatedDate))
                
                newEvent.calendar = self.eventObject!.defaultCalendarForNewEvents
                self.event = newEvent
                do {
                    try self.eventObject!.save(self.event!,span: .thisEvent, commit: true)
                }catch{
                    fatalError("Ошибка создания напоминания!")
                }
                print("Напоминание сохранено!")
            }
    }
    
    func deleteReminder(){
            do{
                try eventObject!.remove(self.event!,span: .thisEvent, commit: true)
            } catch{
                fatalError("Ошибка во время удаления!")
            }
            print("Удаление успешно!")
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
