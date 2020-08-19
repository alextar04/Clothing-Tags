//
//  Sticker+CoreDataClass.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 17.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//
//

import Foundation
import CoreData

//@objc(Sticker)
public class Sticker: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sticker> {
        return NSFetchRequest<Sticker>(entityName: "Sticker")
    }

    @NSManaged public var id: Int16
    @NSManaged public var image: Data?
    @NSManaged public var specification: String?
    @NSManaged public var category: String?
}
