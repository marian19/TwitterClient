//
//  FollowersTableViewController.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import UIKit
import SDWebImage

class FollowersTableViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
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
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.getFollowers()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        
        presenter = FollowerPresenter(view: self)
        presenter?.getFollowers()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
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

extension FollowersTableViewController: UITableViewDelegate,UITableViewDataSource{
    
    
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
        
        if Connectivity.isConnectedToInternet {
            if indexPath.row == followers.count - 1 { // last cell
                presenter?.getFollowers()
            }
        }
        
        return cell
    }
}

