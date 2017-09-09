//
//  FollowerTablePresenter.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation

class FollowerPresenter: BasePresenter,FollowersPresenterProtocol{
    
    weak var view: FollowersViewProtocol?
    let followersDataSource = FollowersDataSource()
    let authentication = Authentication()
    var pageIndex = -1
    
    required init(view: FollowersViewProtocol) {
        self.view = view
    }
    
    // MARK: -  FollowersPresenterProtocol implementation
    
    func getFollowersNextPage(){
        
        if Connectivity.isConnectedToInternet {
            view?.showProgressBar()
            getFollowersData()
            
        }else{
            view?.showErrorMsg(message: "OfflineMessage".localized)
        }
    }
    
    func getFollowers(){
        
        if UserDefaults.standard.object(forKey: Constants.accessToken) == nil {
            getAuthenticationToken()
        }else{
            if UserDefaults.standard.object(forKey: Constants.userID) != nil {
                if Connectivity.isConnectedToInternet {
                    view?.showProgressBar()
                    Follower.deleteAllFollowers()
                    getFollowersData()
                }else{
                    view?.setFollowers(followers: Follower.getAllFollowers())
                }
            }else{
                view?.showLoginButton()
            }
        }
    }
    
    func saveUserData(userID: String){
        
        UserDefaults.standard.set(userID, forKey: Constants.userID)
        getFollowers()
    }
    
    // MARK: -  private instanse methods
    
    private func getFollowersData(){
        let userID = UserDefaults.standard.string(forKey: Constants.userID)!
        
        followersDataSource.getFollowersListFor(userID: userID, pageNumber: pageIndex, compilationHandler: {(followers, pageIndex, error) in
            
            self.view!.hideProgressBar()
            if error == nil{
                self.pageIndex = pageIndex
                self.view!.setFollowers(followers: followers)
            }else{
                self.view!.showErrorMsg(message: (error?.localizedDescription)!)
            }
        })
    }
    
    private func getAuthenticationToken(){
        if Connectivity.isConnectedToInternet {
            view?.showProgressBar()
            authentication.getAccessToken {(token, error) in
                if error == nil{
                    UserDefaults.standard.set(token!, forKey: Constants.accessToken)
                    self.view?.hideProgressBar()
                    self.getFollowers()
                }
            }
        }else{
            view?.showErrorMsg(message: "OfflineMessage".localized)
        }
    }
}
