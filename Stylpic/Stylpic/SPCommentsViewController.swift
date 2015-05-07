//
//  SPCommentsViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/14/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPCommentsViewController: SLKTextViewController {

    var comments: Array<SPActivity> = []
    var imageTapped: ImageIdentifier = ImageIdentifier.ImageOne
    var feedItem: SPFeedItem?
    
    var timer : NSTimer!
    var progress : Float = 0.0
    var progressNavController : MRNavigationBarProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCommentTableViewCell")
        
        progressNavController = MRNavigationBarProgressView(forNavigationController: self.navigationController)
    }
    
    func updateProgressBar(){
        println(progress)
        if(progress >= 1.0){
            timer.invalidate()
            progress = 0.0
        }

        self.progressNavController.progress = progress
        progress += 0.01
    }

    override func didPressRightButton(sender: AnyObject!) {
        //self.feedItem?.commentsCountTwo++
        
        let comment = self.textView.text
        var activityType = ActivityType.CommentImageOne
        if ImageIdentifier.ImageTwo == imageTapped {
            activityType = ActivityType.CommentImageTwo
        }
        
        if let photoPair = self.feedItem?.photos {
            
        
            SPManager.sharedInstance.postComment(activityType, photoPair: photoPair, comment: comment, resultBlock: { (savedObject, error) -> Void in
                if error == nil {
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateProgressBar", userInfo: nil, repeats: true)
                    if let savedObject = savedObject {
                        self.tableView.beginUpdates()
                        self.comments.insert(savedObject, atIndex: 0)
                        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
                        self.tableView.endUpdates()
                        
                        self.tableView.slk_scrollToTopAnimated(true)

                    }
                }
            })
        }
        
        super.didPressRightButton(sender)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailCommentTableViewCell", forIndexPath: indexPath) as! SPFeedDetailCommentTableViewCell
        
        var activity = comments[indexPath.row]
        cell.setupCell(activity)
        //cell.commentLabel.text = activity.objectForKey("content") as! String
        cell.transform = self.tableView.transform;
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func setup( feedItem: SPFeedItem?, imageTapped: ImageIdentifier ) {
        self.imageTapped = imageTapped
        self.feedItem = feedItem
        if let feedItem = self.feedItem, photoPair = feedItem.photos {
            
            var activityType = ActivityType.CommentImageOne
            if ImageIdentifier.ImageTwo == imageTapped {
                activityType = ActivityType.CommentImageTwo
            }
            
            
            SPManager.sharedInstance.fetchComments(photoPair, imageTapped: activityType, resultBlock: { (someComments, error) -> Void in
                if error == nil {
                    if let someComments = someComments {
                        self.comments = someComments
                        if activityType == ActivityType.CommentImageOne {
                            self.feedItem?.comments.commentsPhotoOne = someComments
                        } else {
                            self.feedItem?.comments.commentsPhotoTwo = someComments
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    println( error )
                }
            })
            
            self.tableView.reloadData()
        }
    }
    
}
