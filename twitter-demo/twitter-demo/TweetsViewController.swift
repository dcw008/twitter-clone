//
//  TweetsViewController.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/8/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]!
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        self.tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //get the home timeline
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets:[Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
//            for tweet in tweets{
//                print(tweet.text)
//            }
            
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tweets != nil{
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        return cell
        
    }
    
    //deselects the gray area after user pushes on the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //deselect of the gray cell
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    
    
    @IBAction func onLogOutButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.logout()
    }
    
    
   
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        //check if sender identifier is requesting to see the detailed tweet.
        if(segue.identifier == "viewDetailedTweet"){
            //get the tweet associated with the current cell
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
          
            let tweet = tweets[indexPath!.row]
            
            //print(tweet.text)
            
            let detailViewController = segue.destination as! DetailsTweetController
            
            
            //pass the tweet
            detailViewController.tweet = tweet
            
        }
        
        if(segue.identifier == "createTweet"){
            
            //get the current user
            print("test segue")
            let user = User.currentUser
            
            let createTweetViewController = segue.destination as! CreateTweetViewController
            
            createTweetViewController.currentUser = user
        }
        
    }


}
