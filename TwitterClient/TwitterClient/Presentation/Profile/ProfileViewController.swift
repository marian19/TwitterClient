//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProfileViewController: BaseViewController {
    
    // MARK: -  @IBOutlet

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -  instance variable

    var presenter: ProfilePresenterProtocol?
    var follower: Follower?
    var tweets :[Tweet] = [Tweet]()
    
    // MARK: -  view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.title = follower?.name
        loadUserImages()
        presenter = ProfilePresenter(view: self)
        presenter?.getTimeline(userID: (follower?.id)!)
    }
    
    // MARK: -  instance methods

    private func loadUserImages(){
        if follower?.profileImage == nil{
            profileImageView.sd_setImage(with: URL(string: (follower?.profileImageURL)!))
            
        }else{
            //set image from coredata
            profileImageView.image = UIImage(data:(follower?.profileImage)! as Data , scale:1)
        }
        
        if follower?.backgroundImage == nil{
            backgroundImageView.sd_setImage(with: URL(string: (follower?.backgroundImageURL)!))
            
        }else{
            //set image from coredata
            backgroundImageView.image = UIImage(data:(follower?.backgroundImage)! as Data , scale:1)
        }
    
    }
    
}

// MARK: -  ProfileViewProtocol implementation

extension ProfileViewController: ProfileViewProtocol{
    
    func setTimeline(tweets: [Tweet]){
            if tweets.count > 0{
                self.tweets.append(contentsOf: tweets)
                self.tableView.reloadData()
            }
       
    }
    
    func showErrorMsg(message: String){
        
        alert(message: message)
    }
    func showProgressBar(){
        self.showProgressView()
        
    }
    func hideProgressBar(){
        self.dismissProgressView()
    }
}

// MARK: -  UITableViewDataSource implementation

extension ProfileViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        return tweets.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        cell.tweetTextLabel?.text = tweet.text
        cell.favoriteCountLabel?.text = tweet.favoriteCount
        cell.retweetCountLabel?.text = tweet.retweetCount
        
        return cell
    }
}

// MARK: -  DZNEmptyDataSetSource implementation

extension ProfileViewController: DZNEmptyDataSetSource{
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let string = "NoTweets".localized
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: string, attributes: attrs)
    }
    
}
