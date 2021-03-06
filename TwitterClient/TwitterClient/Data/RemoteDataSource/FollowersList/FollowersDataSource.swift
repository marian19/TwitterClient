//
//  FollowersList.swift
//  TwitterClient
//
//  Created by Marian on 9/7/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct FollowersDataSource {
    
    func getFollowersListFor(userID: String,pageNumber: Int ,compilationHandler:@escaping (_ list: [Follower], _ nextPageNumber:Int,_ error:Error?) -> Void){
        
        let url = UrlsConstants.baseURL + UrlsConstants.Follwers.followersListURL
        
        let parameters: [String : Any] = [DataConstants.Parameters.userID : userID,
                                          DataConstants.Parameters.count: DataConstants.perPage,
                                          DataConstants.Parameters.cursor: pageNumber
        ]
        
        var headers: [String:String] = [:]
        
        if UserDefaults.standard.object(forKey: Constants.accessToken) != nil {
            let token = UserDefaults.standard.string(forKey: Constants.accessToken)!
            if token != "" {
                headers = [
                    "Content-Type" : "application/json",
                    "Authorization": UserDefaults.standard.string(forKey: Constants.accessToken)! ,
                    "Accept": "application/json"
                ]
            }
        }
        
        AlamofireClient.sharedInstance.executeGetRequest(url: url, parameters: parameters, header: headers) { (responseData, error) in
            if error == nil{
                let json =  JSON(responseData ?? "error")
                var followers = [Follower]()
                
                if let followersJsonArray = json["users"].array{
                    let nextPage = json["next_cursor"].intValue
                    
                    for json in followersJsonArray {
                        followers.append(Follower.addFollower(json: json)!)
                    }
                    compilationHandler(followers,nextPage,error)
                }else{
                    compilationHandler(followers,0,error)
                }
            }
        }
    }
}
