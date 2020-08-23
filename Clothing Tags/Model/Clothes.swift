//
//  Clothes+CoreDataClass.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 17.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//
//

import Foundation
import CoreData
import EventKit


public class Clothes: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clothes> {
        return NSFetchRequest<Clothes>(entityName: "Clothes")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var photoClothes: Data?
    @NSManaged public var photoTag: Data?
    @NSManaged public var remindWashing: Date?
    @NSManaged public var eventIdentifier: String?
    @NSManaged public var categoryExternal: Category?
    @NSManaged public var stickersId: String?
}

/*
/**************************************************************************/

// Класс для архивирования и разархивирования События календаря
public class CustomEKEvent: NSObject, NSCoding{
    var event: NSObject!//EKEvent!
    
    init(event: NSObject){//EKEvent){
        self.event = event
    }
    
    public func encode(with coder: NSCoder) {
        //if var eventUnwarped = self.event{
            coder.encode(self.event, forKey: "event")
        //}
    }
    
    public required convenience init?(coder: NSCoder) {
        guard let event = coder.decodeObject(forKey: "event") as? NSObject else{//EKEvent else{
            return nil
        }
        self.init(event: event)
    }
}

@objc(EkEventToDataTransformer)
class EkEventToDataTransformer: ValueTransformer{
    override func transformedValue(_ value: Any?) -> Any? {
        guard let event = value as? CustomEKEvent else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: event)
            return data
        } catch {
            assertionFailure("Failed to transform `EKEvent` to `Data`")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let dataedValue = value as! Data
        let data = try! NSKeyedUnarchiver.unarchiveObject(with: dataedValue)
        return (data as! CustomEKEvent)
    }
}


/**************************************************************************/

// Класс для архивирования и разархивирования Календаря
public class CustomEKEventStore: NSObject, NSCoding{
    var eventStore: NSObject!//EKEventStore!
    
    init(eventStore: NSObject){//EKEventStore){
        self.eventStore = eventStore
    }
    
    public func encode(with coder: NSCoder) {
        if let eventStore = self.eventStore{
            coder.encode(eventStore, forKey: "eventStore")
        }
    }
    
    public required convenience init?(coder: NSCoder) {
        guard let eventStore = coder.decodeObject(forKey: "eventStore") as? NSObject else{ //EKEventStore else{
            return nil
        }
        self.init(eventStore: eventStore)
    }
}


@objc(EkEventStoreToDataTransformer)
class EkEventStoreToDataTransformer: ValueTransformer{
    override func transformedValue(_ value: Any?) -> Any? {
        guard let eventStore = value as? CustomEKEventStore else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: eventStore)
            return data
        } catch {
            assertionFailure("Failed to transform `EKEventStore` to `Data`")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let dataedValue = value as! Data
        let data = try! NSKeyedUnarchiver.unarchiveObject(with: dataedValue)
        return (data as! CustomEKEventStore)
    }
}
*/
