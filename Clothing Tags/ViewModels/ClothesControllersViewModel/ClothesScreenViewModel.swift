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
                newEvent.title = name//self.nameClothesLabel.text
                newEvent.notes = "Необходимо постирать!"

                let updatedDate = time.zeroingSecondsInAlarmForReminders()//self.datePicker.date.zeroingSecondsInAlarmForReminders()
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
}
