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
