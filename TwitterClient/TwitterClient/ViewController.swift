//
//  ViewController.swift
//  TwitterClient
//
//  Created by Marian on 9/6/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Authentication.init().getAccessToken(compilationHandler: { (accessToken, error) in
            ////
            
            if error == nil {
            let defaults = UserDefaults.standard
            //
            defaults.set(accessToken!, forKey: Constants.accessToken)
            }
        })
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                
                
                //
                
                FollowersData.init().getFollowersListFor( userID: (session?.userID)!,pageNumber: -1, compilationHandler: { (followers, nextPage, error) in
                    //                    //
                    
                    
                })
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        //        // Swift
        //        Twitter.sharedInstance().logIn(completion: { (session, error) in
        //            if (session != nil) {
        //                print("signed in as \(session?.userName)");
        //
        ////                FollowersList.init().getAccessToken(kConsumerKey: (session?.authToken)!, kConsumerSecretKey: (session?.authTokenSecret)!, compilationHandler: { (accessToken, error) in
        ////
        ////                })
        //
        //            } else {
        //                print("error: \(error?.localizedDescription)");
        //            }
        //        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

