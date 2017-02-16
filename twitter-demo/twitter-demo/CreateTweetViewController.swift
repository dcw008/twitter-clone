//
//  CreateTweetViewController.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/14/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController {
    
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var currentUser: User!{
        didSet{
            let imageUrl = currentUser.profileUrl!
            self.profileImage.setImageWith(imageUrl as URL)
            self.userNameLabel.text = currentUser.name!
            self.screenNameLabel.text = currentUser.screenname!
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
