//
//  BaseViewController.swift
//  SPOC
//
//  Created by avc on 2017-07-18.
//  Copyright © 2017 avc. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // Mark:- SVProgressHUD Functions
    
    func showProgressView(WithTitle: String = "Loading".localized) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: title)
    }
    
    func dismissProgressView(){
        SVProgressHUD.dismiss()
        
    }
    
    
}
