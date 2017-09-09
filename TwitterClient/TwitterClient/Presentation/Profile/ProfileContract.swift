//
//  FollowerTableContract.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol : class{
    func getTimeline(userID: String)

}

protocol ProfileViewProtocol : class{
    func setTimeline(tweets: [Tweet])
    func showErrorMsg(message: String)
    func showProgressBar()
    func hideProgressBar()
    
}
