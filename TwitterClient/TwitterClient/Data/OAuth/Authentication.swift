//
//  Authentication.swift
//  TwitterClient
//
//  Created by Marian on 9/9/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Authentication {
    
    
    func getAccessToken(compilationHandler:@escaping (_ accessToken: String?,_ error:Error?) -> Void){
        let url = UrlsConstants.baseURL + UrlsConstants.OAuth.OAuthUrl

 
        let credential: String = "\(Constants.consumerKey):\(Constants.consumerSecret)".base64Encoded()!
        
        let headers: [String:String] = ["Authorization":"Basic \(credential)",
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8","Content-Length": "29",
            "Accept-Encoding": "gzip"]
        
        
        let parameters: [String : Any] = ["grant_type":"client_credentials"]

        AlamofireClient.sharedInstance.executePostRequest(url: url, parameters: parameters, header: headers) { (responseData, error) in
            if error == nil{
                let json =  JSON(responseData)
                compilationHandler("bearer \(json["access_token"].stringValue)",error)
                
            }
            
            
        }
        
    }
    
}
