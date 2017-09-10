//
//  Follower+CoreDataProperties.swift
//  
//
//  Created by Marian on 9/9/17.
//
//

import Foundation
import CoreData

extension Follower {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Follower> {
        return NSFetchRequest<Follower>(entityName: "Follower")
    }

    @NSManaged public var backgroundImage: NSData?
    @NSManaged public var bio: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var profileImage: NSData?
    @NSManaged public var profileImageURL: String?
    @NSManaged public var backgroundImageURL: String?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension Follower {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: Tweet)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: Tweet)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}
