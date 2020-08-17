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

@objc(Clothes)
public class Clothes: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clothes> {
        return NSFetchRequest<Clothes>(entityName: "Clothes")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var photoClothes: Data?
    @NSManaged public var photoTag: Data?
    @NSManaged public var remindWashing: Date?
    @NSManaged public var categoryId: Category?
    @NSManaged public var stickerId: NSSet?
    
    @objc(addStickerIdObject:)
    @NSManaged public func addToStickerId(_ value: Sticker)

    @objc(removeStickerIdObject:)
    @NSManaged public func removeFromStickerId(_ value: Sticker)

    @objc(addStickerId:)
    @NSManaged public func addToStickerId(_ values: NSSet)

    @objc(removeStickerId:)
    @NSManaged public func removeFromStickerId(_ values: NSSet)
}
