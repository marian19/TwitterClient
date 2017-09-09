//
//  FollowersTableViewController.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import UIKit
import SDWebImage
import DZNEmptyDataSet

class FollowersTableViewController: BaseViewController {
    
    // MARK: -  @IBOutlet

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -  instance variable

    var followers :[Follower] = [Follower]()
    var loginButton: TWTRLogInButton?
    var presenter: FollowersPresenterProtocol?
    
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = Colors.mainColor
        return refreshControl
    }()
    
    // MARK: -  selector

    func handleRefresh(_ refreshControl: UIRefreshControl) {
         followers = [Follower]()
        presenter?.getFollowers()
        
    }
    
    // MARK: -  view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        self.title = "Followers".localized
        presenter = FollowerPresenter(view: self)
        presenter?.getFollowers()
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let row = self.tableView.indexPathForSelectedRow?.row
        let profileViewController = segue.destination as! ProfileViewController
        profileViewController.follower = followers[row!]
    }
}

// MARK: -  FollowersViewProtocol implementation

extension FollowersTableViewController: FollowersViewProtocol{
    
    func showLoginButton(){
        tableView.isHidden = true
        loginButton = TWTRLogInButton(logInCompletion: {[weak self] session, error in
            if (session != nil) {
                self?.loginButton?.removeFromSuperview()
                self?.tableView.isHidden = false
                print("signed in as \(String(describing: session?.userName))");
                self?.presenter?.saveUserData(userID: (session?.userID)!)
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        loginButton?.center = self.view.center
        self.view.addSubview(loginButton!)
    }
    
    func setFollowers(followers: [Follower]){
        refreshControl.endRefreshing()
        if Connectivity.isConnectedToInternet{
            if followers.count > 0{
                self.followers.append(contentsOf: followers)
                self.tableView.reloadData()
            }
        }else{
            if self.followers.count == 0{
                self.followers = followers
                self.tableView.reloadData()
            }
        }
    }
   
    func showErrorMsg(message: String){
        refreshControl.endRefreshing()
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

extension FollowersTableViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.estimatedRowHeight = 44.0 // standard tableViewCell height
        tableView.rowHeight = UITableViewAutomaticDimension
        return followers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FollowersTableViewCell
        let follower = followers[indexPath.row]
        cell.nameLabel.text = follower.name
        cell.bioLabel.text = follower.bio
        if follower.profileImage == nil{
            cell.userImageView.sd_setImage(with: URL(string: follower.profileImageURL!))
            
        }else{
            cell.userImageView.image = UIImage(data:follower.profileImage! as Data , scale:1)
        }
        cell.updateConstraintsIfNeeded()
        
        // get followers next page if connected to internet
        if Connectivity.isConnectedToInternet {
            if indexPath.row == followers.count - 1 { // last cell
                presenter?.getFollowers()
            }
        }
        
        return cell
    }
}

// MARK: -  DZNEmptyDataSetSource implementation

extension FollowersTableViewController: DZNEmptyDataSetSource{
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let string = "NoFollower".localized
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: string, attributes: attrs)
    }
}

