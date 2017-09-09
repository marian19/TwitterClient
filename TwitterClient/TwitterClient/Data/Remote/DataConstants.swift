//
//  DataConstant.swift
//  TwitterClient
//
//  Created by Marian on 9/7/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation

struct DataConstants{
    
    static let perPage = 20

    struct Parameters {
        static let count = "count"
        static let cursor = "cursor"
        static let userID = "user_id"
    }
    
    struct FollwersData {
        static let id = "id"
        static let name = "name"
        static let description = "description"
        static let backgroundImageURL = "profile_banner_url"
        static let profileImageURL = "profile_image_url_https"
    }

    struct TimelineData {
        static let user = "user"
        static let id = "id"
        static let text = "text"
        static let retweetCount = "retweet_count"
        static let favoriteCount = "favorite_count"
    }

}
