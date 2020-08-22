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
        setSocialNetworksLogos()
        stickers = getStickersByIdsString((clothes?.stickersId)!)
    }
    
    func getClothesFromId(_ id: Int)->Clothes{
        let request: NSFetchRequest<Clothes> = Clothes.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", String(id))
        do{
            let clothesList = try AppDelegate.appDelegateLink.storage!.getContext().fetch(request)
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
    
    
    func setSocialNetworksLogos(){
        socialNetworksLogos = SocialNetwork().listLogos
    }
    
    
    func getStickersByIdsString(_ stickersIds: String)->[Sticker]{
        let listStickersIds = getStickersIdFromString(stickersIds)
        var listStickers = [Sticker]()
        
        listStickersIds.map{
            listStickers.append(getStickerFromId($0))
        }
        
        return listStickers
    }
    
    
    func addReminder(name: String?, time: Date){
            eventObject = EKEventStore()
            eventObject!.requestAccess(to: .event){ granted, error in
                let newEvent = EKEvent(eventStore: self.eventObject!)
                newEvent.title = name
                newEvent.notes = "Необходимо постирать!"

                let updatedDate = time.zeroingSecondsInAlarmForReminders()
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
    
    func addReminderToDatabase(time: Date){
        let storage = AppDelegate.appDelegateLink.storage
        clothes?.remindWashing = time
        storage?.saveContext()
    }
    
    func deleteReminderFromDatabase(){
        let storage = AppDelegate.appDelegateLink.storage
        clothes?.remindWashing = nil
        storage?.saveContext()
    }
}
