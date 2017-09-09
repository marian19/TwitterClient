//
//  TweetsDataSource.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation

import SwiftyJSON
import Alamofire

struct TweetsDataSource {
    
    func getTweetsFor(userID: String,compilationHandler:@escaping (_ list: [Tweet],_ error:Error?) -> Void){
        
        let url = UrlsConstants.baseURL + UrlsConstants.Timeline.timelineURL
        
        let parameters: [String : Any] = [DataConstants.Parameters.userID : userID,
                                          DataConstants.Parameters.count: 10]
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
            var tweets = [Tweet]()
            
            if error == nil{
                let jsonArray =  JSON(responseData ?? "error")
                
                for(_, json) in jsonArray {
                    tweets.append(Tweet.addTweet(json: json)!)
                }
                compilationHandler(tweets,error)
            }else{
                compilationHandler(tweets,error)
            }
        }
    }
}
