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


public class Clothes: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clothes> {
        return NSFetchRequest<Clothes>(entityName: "Clothes")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var photoClothes: Data?
    @NSManaged public var photoTag: Data?
    @NSManaged public var remindWashing: Date?
    @NSManaged public var categoryExternal: Category?
    @NSManaged public var stickerExternal: NSSet?
    
    @objc(addStickerExternalObject:)
    @NSManaged public func addToStickerExternal(_ value: Sticker)

    @objc(removeStickerExternalObject:)
    @NSManaged public func removeFromStickerExternal(_ value: Sticker)

    @objc(addStickerExternal:)
    @NSManaged public func addToStickerExternal(_ values: NSSet)

    @objc(removeStickerExternal:)
    @NSManaged public func removeFromStickerExternal(_ values: NSSet)
}
