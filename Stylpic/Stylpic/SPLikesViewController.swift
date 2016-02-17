//
//  SPLikesViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/11/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPLikesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var likes: Array<SPActivity> = []
    var imageTapped: ImageIdentifier = ImageIdentifier.ImageOne
    var feedItem: SPFeedItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "SPLikesTableViewCell", bundle: nil), forCellReuseIdentifier: "SPLikesTableViewCell")
        
        let activityType: ActivityType
        switch imageTapped {
        case .ImageOne:
            activityType = .LikeImageOne
            break
        case .ImageTwo:
            activityType = .LikeImageTwo
            break
        }
                
        SPManager.sharedInstance.getPhotoPairLikes(feedItem.photos!.objectId!, likesPhotoIdentifier: activityType) { (activities, error) -> Void in
                        if error == nil {
                            if let activities = activities {
                                self.likes = activities
                                self.tableView.reloadData()
                            }
                        }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPLikesTableViewCell", forIndexPath: indexPath) as! SPLikesTableViewCell
        cell.setupCell(likes[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likes.count
    }
}
