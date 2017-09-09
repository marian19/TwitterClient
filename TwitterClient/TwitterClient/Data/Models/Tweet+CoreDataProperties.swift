//
//  Tweet+CoreDataProperties.swift
//  
//
//  Created by Marian on 9/9/17.
//
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet")
    }
    @NSManaged public var id: String?
    @NSManaged public var favoriteCount: String
    @NSManaged public var retweetCount: String
    @NSManaged public var text: String?
    @NSManaged public var user: Follower?

}
