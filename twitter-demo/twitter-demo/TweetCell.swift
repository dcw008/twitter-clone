//
//  TweetCell.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/8/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var hasRetweeted = false
    var hasFavorited = false
    
    var tweet: Tweet?{
        
        didSet{
            if let tweet = tweet{
                self.userName.text = tweet.userName!
                self.screenName.text = tweet.screenName!
                
                self.tweetText.text = tweet.text!
                let imageUrlString = tweet.profileImageUrl
                let imageUrl = URL(string: imageUrlString!)
                self.profilePicture.setImageWith(imageUrl!)
                
                
                let date = tweet.timeStamp!
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMM YY"
                let timestamp = formatter.string(from: date)
              
                self.timeStamp.text = "\(timestamp)"
                
                self.retweetCountLabel.text = "\(tweet.retweetCount)"
                self.favoriteLabel.text = "\(tweet.favoritesCount)"

                                
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.layer.cornerRadius = 3
        //clip the bitmap the imageview contains
        profilePicture.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onFavoritesClicked(_ sender: Any) {
        if(hasFavorited == false){
            tweet?.favoritesCount += 1
            hasFavorited = true
        } else{
            tweet?.favoritesCount -= 1
            hasFavorited = false
        }
        self.favoriteLabel.text = "\(tweet!.favoritesCount)"
       
    }
    
    @IBAction func onRetweetClicked(_ sender: Any) {
        if(hasRetweeted == false){
            tweet?.retweetCount += 1
            hasRetweeted = true
        } else{
            tweet?.retweetCount -= 1
            hasRetweeted = false
        }
        self.retweetCountLabel.text = "\(tweet!.retweetCount)"
    }
    
}
