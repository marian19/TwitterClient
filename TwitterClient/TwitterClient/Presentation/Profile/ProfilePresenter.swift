//
//  FollowerTablePresenter.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation

class ProfilePresenter: BasePresenter,ProfilePresenterProtocol{
    
    weak var view: ProfileViewProtocol?
    let tweetsDataSource = TweetsDataSource()
    
    required init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    // MARK: -  ProfilePresenterProtocol implementation

    func getTimeline(userID: String){
        
        if Connectivity.isConnectedToInternet {
            view?.showProgressBar()
            tweetsDataSource.getTweetsFor(userID: userID, compilationHandler: { (tweets, error) in
                self.view!.hideProgressBar()
                if error == nil{
                    self.view!.setTimeline(tweets: tweets)
                }else{
                    self.view!.showErrorMsg(message: (error?.localizedDescription)!)
                }
            })
        }else{
            // get tweets from coredata
            view?.setTimeline(tweets: Tweet.getTweetsFor(userId: userID)!)
        }
    
    }
    
}
