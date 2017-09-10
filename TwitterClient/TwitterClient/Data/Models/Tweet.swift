//
//  Tweet+CoreDataClass.swift
//
//
//  Created by Marian on 9/9/17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Tweet)
public class Tweet: NSManagedObject {
    
    static func getTweetWith(id:String) -> Tweet? {
        
        let context = CoreDataManager.sharedInstance.managedObjectContext
        var tweet: Tweet?
        do {
            let fetchRequest : NSFetchRequest<Tweet> = Tweet.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "id LIKE[cd] %@", id)
            
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.first != nil {
                tweet = fetchedResults.first
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        return tweet
    }
    
    static func deleteAllTweets()  {
        let context = CoreDataManager.sharedInstance.managedObjectContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try context.execute(request)
        } catch {
            print("delete error")
        }
    }
    
    
    static func addTweet(json: JSON) -> Tweet? {
        
        let context = CoreDataManager.sharedInstance.managedObjectContext
        let id = json[DataConstants.TimelineData.id].stringValue
        var tweet = Tweet.getTweetWith(id: id)
        let userID = json[DataConstants.TimelineData.user][DataConstants.TimelineData.id].stringValue
        
        let follower = Follower.getFollowerWith(id: userID)
        if tweet == nil{
            tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: context) as? Tweet
        }
        tweet?.id = json[DataConstants.TimelineData.id].stringValue
        tweet?.text = json[DataConstants.TimelineData.text].stringValue
        tweet?.retweetCount = json[DataConstants.TimelineData.retweetCount].stringValue
        tweet?.favoriteCount = json[DataConstants.TimelineData.favoriteCount].stringValue
        tweet?.user = follower
        do {
            try context.save()
            print("Saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return tweet
        
    }
    

    static func getTweetsFor(userId:String) -> [Tweet]? {
        
        let context = CoreDataManager.sharedInstance.managedObjectContext
        var tweets = [Tweet]()
        
        do {
            let fetchRequest : NSFetchRequest<Tweet> = Tweet.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "user.id LIKE[cd] %@", userId)
            
            let fetchedResults = try context.fetch(fetchRequest)
            tweets = fetchedResults
        }
        catch {
            print ("fetch task failed", error)
        }
        return tweets
    }
    
    
}
