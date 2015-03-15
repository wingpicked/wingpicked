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
    var comments = ["Hey", "What's up", "Dayum Shawty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "SPFeedDetailCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCommentTableViewCell")

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
        self.tableView.beginUpdates()
        self.comments.insert(comment, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        self.tableView.endUpdates()
        
        self.tableView.slk_scrollToTopAnimated(true)
        super.didPressRightButton(sender)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailCommentTableViewCell", forIndexPath: indexPath) as! SPFeedDetailCommentTableViewCell
        
        cell.commentLabel.text = comments[indexPath.row]
        cell.transform = self.tableView.transform;
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
}
