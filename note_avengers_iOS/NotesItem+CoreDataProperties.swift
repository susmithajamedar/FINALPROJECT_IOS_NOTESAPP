//
//  NotesItem+CoreDataProperties.swift
//  note_avengers_iOS
//
//  Created by Vijay Kumar Sevakula on 2021-05-27.
//
//

import Foundation
import CoreData


extension NotesItem {

    @nonobjc public class func fetchCoreRequest() -> NSFetchRequest<NotesItem> {
        return NSFetchRequest<NotesItem>(entityName: "NotesItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var address: String?
    @NSManaged public var audio: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var photo: Data?
    @NSManaged public var longitude: Double
    @NSManaged public var time: Double
    @NSManaged public var subject: String?

}

extension NotesItem : Identifiable {

}
