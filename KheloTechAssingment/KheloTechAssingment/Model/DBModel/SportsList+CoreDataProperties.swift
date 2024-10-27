//
//  SportsList+CoreDataProperties.swift
//  KheloTechAssingment
//
//  Created by Abhinav on 26/10/24.
//
//

import Foundation
import CoreData


extension SportsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SportsList> {
        return NSFetchRequest<SportsList>(entityName: "SportsList")
    }

    @NSManaged public var sportID: Int64
    @NSManaged public var nsrsSportID: Int64
    @NSManaged public var sportName: String?
    @NSManaged public var rfSportDBName: String?
    @NSManaged public var status: String?

}

extension SportsList : Identifiable {

}
