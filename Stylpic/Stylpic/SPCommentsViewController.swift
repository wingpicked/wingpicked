//
//  SPCommentsViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/14/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPCommentsViewController: SLKTextViewController {

//    override init() {
//        super.init(tableViewStyle: UITableViewStyle.Plain)
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    var comments = ["Hey", "What's up", "Dayum Shawty"]
    var comments: Array<PFObject>?
    var imageTapped: ImageIdentifier = ImageIdentifier.ImageOne
    var feedItem: SPFeedItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCommentTableViewCell")

        self.leftButton.setImage(UIImage(named: "Button_like_selected"), forState: UIControlState.Normal)
        
//        var likeButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
//        likeButton.frame = CGRectMake(8, 16, 24, 24)
//        likeButton.setImage(UIImage(named: "Button_like_selected"), forState: UIControlState.Normal)
//        likeButton.targetForAction(Selector("didTapLikeButton:"), withSender: self)
//        likeButton.addTarget(self, action: Selector("didTapLikeButton:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    

    
    override func didPressLeftButton(sender: AnyObject!) {
        println("Like")
        
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        
        let comment = self.textView.text
        var activityType = ActivityType.CommentImageOne
        if ImageIdentifier.ImageTwo == imageTapped {
            activityType = ActivityType.CommentImageTwo
        }
        
        if let photoPair = self.feedItem?.photos {
            
        
            SPManager.sharedInstance.postComment(activityType, photoPair: photoPair, comment: comment, resultBlock: { (savedObject, error) -> Void in
                if error == nil {
                    if let savedObject = savedObject {
                        self.tableView.beginUpdates()
                        self.comments?.insert(savedObject, atIndex: 0)
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
        
        var activity = comments?[indexPath.row]
        cell.commentLabel.text = activity?.objectForKey("content") as! String
        cell.transform = self.tableView.transform;
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var commentCount = 0
        if let comments = comments {
            commentCount = comments.count
        }
        
        return commentCount
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
