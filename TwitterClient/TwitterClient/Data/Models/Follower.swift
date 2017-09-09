//
//  Follower+CoreDataClass.swift
//
//
//  Created by Marian on 9/9/17.
//
//

import Foundation
import CoreData
import SwiftyJSON
import Alamofire
import AlamofireImage

@objc(Follower)
public class Follower: NSManagedObject {
    
    static func getFollowerWith(id:String) -> Follower? {
        
        let context = CoreDataManager.sharedInstance.managedObjectContext
        var follower: Follower?
        do {
            let fetchRequest : NSFetchRequest<Follower> = Follower.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "id LIKE[cd] %@", id)
            
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.first != nil {
                follower = fetchedResults.first
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        return follower
    }
    
    static func deleteAllFollowers()  {
        
        let context = CoreDataManager.sharedInstance.managedObjectContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Follower")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try context.execute(request)
        } catch {
            print("delete error")
        }
    }
    
    
    static func addFollower(json: JSON) -> Follower? {
        
        let context = CoreDataManager.sharedInstance.managedObjectContext
        let userID = json[DataConstants.FollwersData.id].stringValue
        var follower = Follower.getFollowerWith(id: userID)
        if follower == nil{
            follower = NSEntityDescription.insertNewObject(forEntityName: "Follower", into: context) as? Follower
        }
        follower?.id = json[DataConstants.FollwersData.id].stringValue
        follower?.name = json[DataConstants.FollwersData.name].stringValue
        follower?.bio = json[DataConstants.FollwersData.description].stringValue
        let backgroundImageURL = json[DataConstants.FollwersData.backgroundImageURL].stringValue
        let  profileImageURL = json[DataConstants.FollwersData.profileImageURL].stringValue
        follower?.backgroundImageURL = backgroundImageURL
        follower?.profileImageURL = profileImageURL
        Alamofire.request(profileImageURL).responseImage { response in
            if let image = response.result.value {
                follower?.profileImage = UIImagePNGRepresentation(image) as NSData?
                Alamofire.request(backgroundImageURL).responseImage { response in
                    if let image = response.result.value {
                        follower?.backgroundImage = UIImagePNGRepresentation(image) as NSData?
                        do {
                            try context.save()
                            print("Saaaaavvvveeeddd")
                            
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
        }

        return follower
    }
    
    static func getAllFollowers() -> [Follower]{
        
        var followers  = [Follower]()
        let context = CoreDataManager.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Follower")
        do {
            try
                followers = context.fetch(fetchRequest) as! [Follower]
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return followers
    }
    
}
