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
    let followersData = FollowersData()
    let authentication = Authentication()
    var pageIndex = -1
    var loginButton: TWTRLogInButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()

        if UserDefaults.standard.object(forKey: Constants.accessToken) == nil {
            getAuthenticationToken()
        }else{
            
            if UserDefaults.standard.object(forKey: Constants.userID) != nil {
                
                getFollowers()
            }else{
                loginUser()
            }
        }
    }
    
    private func getAuthenticationToken(){
        self.showProgressView()
        authentication.getAccessToken { [weak self](token, error) in
            if error == nil{
                UserDefaults.standard.set(token!, forKey: Constants.accessToken)
                self?.dismissProgressView()
                self?.loginUser()
            }
            
        }
        
    }
    
    private func loginUser(){
        tableView.isHidden = true
        loginButton = TWTRLogInButton(logInCompletion: {[weak self] session, error in
            if (session != nil) {
                self?.loginButton?.removeFromSuperview()
                self?.tableView.isHidden = false
                print("signed in as \(String(describing: session?.userName))");
                
                UserDefaults.standard.set(session?.userID, forKey: Constants.userID)
                
                self?.getFollowers()
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        loginButton?.center = self.view.center
        self.view.addSubview(loginButton!)
    }
    
    fileprivate func getFollowers(){
        self.showProgressView()
        
        let userID = UserDefaults.standard.string(forKey: Constants.userID)!
        
        followersData.getFollowersListFor(userID: userID, pageNumber: pageIndex, compilationHandler: {[weak self] (followers, pageIndex, error) in
            self?.dismissProgressView()
            
            if followers.count > 0{
                self?.pageIndex = pageIndex
                self?.followers.append(contentsOf: followers)
                self?.tableView.reloadData()
            }
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension FollowersTableViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 44.0 // standard tableViewCell height
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FollowersTableViewCell
        cell.sizeToFit()
        cell.nameLabel.text = followers[indexPath.row].name
        cell.bioLabel.text = followers[indexPath.row].description
        cell.userImageView.sd_setImage(with: URL(string: followers[indexPath.row].profileImageURL))
        cell.updateConstraintsIfNeeded()

        
        
        if indexPath.row == followers.count - 1 { // last cell
            getFollowers()
        }
        return cell
        
        
    }
    
}

