//
//  TwitterClient.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/4/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let oAuthBaseUrl = "https://api.twitter.com"
    static let sendTweetEndPoint = TwitterClient.oAuthBaseUrl + "/1.1/statuses/update.json?status="
    static let retweetEndpoint = TwitterClient.oAuthBaseUrl + "/1.1/statuses/retweet/:id.json"
    
    var loginSuccess: (()->())?
    var loginFailure: ((Error)->())?
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "mWMxbbR2PFmUE1Bk9WV0l1NPK", consumerSecret: "DnSsn308le2mQK7UsKNrTMrXb8p6WlskBd0Otalpgtp933QIgI")
    
    
    func logIn(success: @escaping () -> (), failure: @escaping  (Error) -> () ){
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            //print("I got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            
            
            UIApplication.shared.openURL(url as URL)
        }, failure: { (error: Error?) -> Void in
            print("error \(error!.localizedDescription)")
            self.loginFailure!(error!)
        })

    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) in
                //call the setter and save to disk
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }) { (error: Error?) -> Void in
            self.loginFailure?(error!)
        }

    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            
            success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
                            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)
        })
    }
    
    

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //print("account \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })

    }
    
    //request to post a tweet
//    func postTweet(text: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()){
//        post("1.1/statuses/update.json", parameters: text, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//            let newTweet = response as! Tweet
//            success(newTweet)
//        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
//            failure(error)
//        })
//
//        
//    }
    
    class func sendTweet(text: String, callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{
            callBack(nil, nil)
            return
        }
        let urlString = TwitterClient.sendTweetEndPoint + encodedText
        let _ = TwitterClient.sharedInstance?.post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let tweetDict = response as? [String: Any]{
                let tweet = Tweet(dictionary: tweetDict as NSDictionary) //make sure you have your Tweet model ready, and its initializer should take a dictionary as the parameter
                callBack(tweet, nil)
            }else{
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    class func retweet(id: String, callBack: @escaping (_ response: Tweet?, _ error: Error?) -> Void){
        TwitterClient.sharedInstance?.post(retweetEndpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweetDict = response as? [String: Any]{
                var tweet: Tweet?
                if let originalTweetDict = tweetDict["retweeted_status"] as? [String: Any]{
                    tweet = Tweet(dictionary: originalTweetDict as NSDictionary)
                }
                
                callBack(tweet, nil)
            } else {
                callBack(nil, nil)
            }
        
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            callBack(nil, error)
            
        })
    }

    func logout(){
        deauthorize()
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogutNotification), object: nil )
    }
    

}
