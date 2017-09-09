//
//  APIsUrls.swift
//  TwitterClient
//
//  Created by Marian on 9/7/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation

struct UrlsConstants {
    
    static let baseURL = "https://api.twitter.com/"
    
    struct Follwers {
        static let followersListURL = "1.1/followers/list.json"
    }
    

    struct OAuth {
        static let OAuthUrl = "oauth2/token"
    }
}
