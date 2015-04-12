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
    var feedItem: SPFeedItem?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "SPLikesTableViewCell", bundle: nil), forCellReuseIdentifier: "SPLikesTableViewCell")
        
        
//        SPManager.sharedInstance.postComment(activityType, photoPair: photoPair, comment: comment, resultBlock: { (savedObject, error) -> Void in
//            if error == nil {
//                if let savedObject = savedObject {
//                    self.tableView.beginUpdates()
//                    self.comments.insert(savedObject, atIndex: 0)
//                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
//                    self.tableView.endUpdates()
//                }
//            }
//        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPLikesTableViewCell", forIndexPath: indexPath) as! SPLikesTableViewCell
        
        var activity = likes[indexPath.row]
        cell.textLabel?.text = "Hi"
        //cell.setupCell(activity)
        //cell.commentLabel.text = activity.objectForKey("content") as! String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likes.count
    }
    
//    func setup( feedItem: SPFeedItem?, imageTapped: ImageIdentifier ) {
//        self.imageTapped = imageTapped
//        self.feedItem = feedItem
//        if let feedItem = self.feedItem, photoPair = feedItem.photos {
//            
//            var activityType = ActivityType.CommentImageOne
//            if ImageIdentifier.ImageTwo == imageTapped {
//                activityType = ActivityType.CommentImageTwo
//            }
//            
//            
//            SPManager.sharedInstance.fetchComments(photoPair, imageTapped: activityType, resultBlock: { (someComments, error) -> Void in
//                if error == nil {
//                    if let someComments = someComments {
//                        self.likes = someComments
//                        if activityType == ActivityType.CommentImageOne {
//                            self.feedItem?.comments.commentsPhotoOne = someComments
//                        } else {
//                            self.feedItem?.comments.commentsPhotoTwo = someComments
//                        }
//                        self.tableView.reloadData()
//                    }
//                } else {
//                    println( error )
//                }
//            })
//            
//            self.tableView.reloadData()
//        }
//    }

}
