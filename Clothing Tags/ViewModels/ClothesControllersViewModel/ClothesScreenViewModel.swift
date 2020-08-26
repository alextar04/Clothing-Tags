//
//  ClothesScreenViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 22.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import EventKit

class ClothesScreenViewModel{
    var clothes: Clothes? = nil
    var stickers: [Sticker]? = nil
    var socialNetworksLogos = [UIImage]()
    
    var eventObject: EKEventStore? = nil
    var event: EKEvent? = nil
    
    init(idClothes: Int){
        clothes = getClothesFromId(idClothes)
        stickers = getStickersByIdsString((clothes?.stickersId)!)
        
        // Если событие закончилось -> удалить его
        var store = EKEventStore()
        if clothes?.remindWashing != nil{
            let searchedEvent:EKEvent? = store.event(withIdentifier: (clothes?.eventIdentifier)!)
            if searchedEvent == nil{
                let storage = AppDelegate.appDelegateLink.storage
                clothes?.remindWashing = nil
                clothes?.eventIdentifier = nil
                storage?.saveContext()
            }
        }
    }
    
    func getClothesFromId(_ id: Int)->Clothes{
        let request: NSFetchRequest<Clothes> = Clothes.fetchRequest()
        var clothesList = [Clothes]()
        do{
            let clothesAllList = try AppDelegate.appDelegateLink.storage!.getContext().fetch(request)
            for item in clothesAllList{
                if item.id == id{
                    clothesList.append(item)
                    break
                }
            }
            
            return clothesList.first!
        } catch{
            fatalError("Ошибка получения одежды по Id!")
        }
    }
    
    // Удалить одежду, используя ее Id
    // Удалить соответствующую категорию, если она оказалась пуста
    func deleteClothesFromId(_ id: Int){
        let storage = AppDelegate.appDelegateLink.storage
        
        // Удаление одежды
        let clothes = getClothesFromId(id)
        let category = clothes.categoryExternal
        storage?.getContext().delete(clothes)
        
        // Удаление категории
        if getClothesByIdCategory(idCategory: Int((category?.id)!))?.count == 0{
            storage?.getContext().delete(category!)
        }
        
        storage!.saveContext()
    }
    
    
    func getClothesByIdCategory(idCategory: Int)->[Clothes]?{
        let storage = AppDelegate.appDelegateLink.storage!
        let request: NSFetchRequest<Clothes> = Clothes.fetchRequest()
        request.predicate = NSPredicate(format: "categoryExternal.id = %@", String(idCategory))
        
        do{
            let clothes = try storage.getContext().fetch(request)
            return clothes
        }catch{
            print("Неудачный запрос списка одежды для категории с id = \(idCategory)!")
            return nil
        }
    }
    
    func getStickersByIdsString(_ stickersIds: String)->[Sticker]{
        let listStickersIds = getStickersIdFromString(stickersIds)
        var listStickers = [Sticker]()
        
        listStickersIds.map{
            listStickers.append(getStickerFromId($0))
        }
        
        return listStickers
    }
    
    // Получение строки с описаниями стикеров
    func getStickersDescription()->String{
        var descriptionList = [String]()
        stickers?.map{sticker in
            descriptionList.append(sticker.specification!)
        }
        return descriptionList.joined(separator: "\n\n")
    }
    
    func addReminder(name: String?, time: Date){
            eventObject = EKEventStore()
            eventObject!.requestAccess(to: .event){granted, error in
                let newEvent = EKEvent(eventStore: self.eventObject!)
                newEvent.title = name
                newEvent.notes = "Необходимо постирать!"

                let updatedDate = time.zeroingSecondsInAlarmForReminders()
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
                
                self.clothes?.setValue(newEvent.eventIdentifier, forKey: "eventIdentifier")
                self.addReminderToDatabase(time: time)
            }
    }
    
    
    func deleteReminder(){
            do{
                // Вернем нужную запись по идентификатору
                var store = EKEventStore()
                let searchedEvent:EKEvent? = store.event(withIdentifier: (clothes?.eventIdentifier)!)
                if searchedEvent == nil{
                    return
                }
                    try store.remove(searchedEvent!, span: .thisEvent, commit: true)
            } catch{
                    fatalError("Ошибка во время удаления!")
                    }
            print("Удаление успешно!")
    }
    
    func addReminderToDatabase(time: Date){
        let storage = AppDelegate.appDelegateLink.storage
        clothes?.setValue(time, forKey: "remindWashing")
        storage?.saveContext()
    }
    
    func deleteReminderFromDatabase(){
        let storage = AppDelegate.appDelegateLink.storage
        clothes?.setValue(nil, forKey: "remindWashing")
        clothes?.setValue(nil, forKey: "eventIdentifier")
        storage?.saveContext()
    }
}
