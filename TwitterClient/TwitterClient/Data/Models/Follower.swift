//
//  Follower.swift
//  TwitterClient
//
//  Created by Marian on 9/7/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Follower {
    
    let id: Int
    let name: String
    let description: String
    let backgroundImageURL: String
    let profileImageURL: String

    init(json: JSON) {
        id = json[DataConstants.FollwersData.id].intValue
        name = json[DataConstants.FollwersData.name].stringValue
        description = json[DataConstants.FollwersData.description].stringValue
        backgroundImageURL = json[DataConstants.FollwersData.backgroundImageURL].stringValue
        profileImageURL = json[DataConstants.FollwersData.profileImageURL].stringValue
    }
}
