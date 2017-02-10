//
//  Tweet.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/4/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: NSDictionary?
    var userName: String?
    var screenName: String?
    var profileImageUrl: String?
    var text: String?
    var timeStamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        screenName = dictionary["screen_name"] as? String
        user = dictionary["user"] as? NSDictionary
        profileImageUrl = user!["profile_image_url_https"] as? String
        userName = user!["name"] as? String
        
        let timeStampString = dictionary["created_at"] as? String
        
        
        if let timeStampString = timeStampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Zy"
            timeStamp = formatter.date(from: timeStampString)
        }
        
        
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        //iterate through all dictionary and create a tweet based on the dictionary and then add it back to the array
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
        
    }
}
