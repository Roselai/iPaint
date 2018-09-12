//
//  Doodle+CoreDataProperties.swift
//  
//
//  Created by Shukti Shaikh on 9/11/18.
//
//

import Foundation
import CoreData


extension Doodle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Doodle> {
        return NSFetchRequest<Doodle>(entityName: "Doodle")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var image: NSData?

}
