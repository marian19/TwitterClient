//
//  FollowerTableContract.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation

protocol FollowersPresenterProtocol : class{
    func getFollowers()
    func getFollowersNextPage()
    func saveUserData(userID: String)

}

protocol FollowersViewProtocol : class{
    func showLoginButton()
    func setFollowers(followers: [Follower])
    func showErrorMsg(message: String)
    func showProgressBar()
    func hideProgressBar()
    
}
