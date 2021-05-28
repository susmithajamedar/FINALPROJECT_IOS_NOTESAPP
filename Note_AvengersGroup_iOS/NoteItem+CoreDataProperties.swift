//
// NoteItem+CoreDataProperties.swift
//  Note_AvengersGroup_iOS
//
//

import Foundation
import CoreData


extension NoteItem {

    @nonobjc public class func fetchCoreRequest() -> NSFetchRequest<NoteItem> {
        return NSFetchRequest<NoteItem>(entityName: "NoteItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var time: Double
    @NSManaged public var subject: String?
    @NSManaged public var photo: Data?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var id: String?
    @NSManaged public var body: String?
    @NSManaged public var audio: String?
    @NSManaged public var address: String?

}

extension NoteItem : Identifiable {

}
