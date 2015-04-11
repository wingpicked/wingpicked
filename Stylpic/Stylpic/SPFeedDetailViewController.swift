//
//  SPFeedDetailViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 2/8/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit


class SPFeedDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SPLikeCommentButtonViewDelegate, SPCommentsSmallTableViewCellDelegate {
    
    @IBOutlet weak var commentInputAccessoryView: CommentInputAccessoryView!
//    var comments = ["Hello", "hahaha", "you look nice!"]
    lazy var inputAccessoryViewz : UIView = CommentInputAccessoryView()

    //@IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var imageFile : PFFile
    var feedItem: SPFeedItem
    var imageTapped : ImageIdentifier
    var tableViewFooterView : SPLikeCommentButtonView!
    
    init(feedItem : SPFeedItem, imageTapped: ImageIdentifier) {
        self.imageTapped = imageTapped
        self.feedItem = feedItem
        
        
        var imageTapedKey = "photoTwo"
        if imageTapped == ImageIdentifier.ImageOne {
            imageTapedKey = "photoOne"
        }
        
        let photo = self.feedItem.photos?.objectForKey(imageTapedKey) as! SPPhoto
        
        self.imageFile = photo.photo
        super.init(nibName: "SPFeedDetailViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.imageFile = PFFile() //TODO: Place default image here.
        self.feedItem = SPFeedItem()
        self.imageTapped = ImageIdentifier.ImageOne
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "SPFeedDetailPictureTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailPictureTableViewCell")
        self.tableView.registerNib(UINib(nibName:"SPCommentsSmallTableViewCell", bundle: nil), forCellReuseIdentifier: "SPCommentsSmallTableViewCell")
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailCollaborationTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCollaborationTableViewCell")
        self.tableViewFooterView = NSBundle.mainBundle().loadNibNamed("SPLikeCommentButtonView", owner: self, options: nil).first as! SPLikeCommentButtonView
        self.tableViewFooterView.delegate = self
        self.tableView.tableFooterView = tableViewFooterView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //TODO: Refactor this to get a base cell or something out of here so there isn't duplicate code.
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailPictureTableViewCell", forIndexPath: indexPath) as! SPFeedDetailPictureTableViewCell
            cell.setupCell(imageFile)
            return cell
        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailCollaborationTableViewCell", forIndexPath: indexPath) as! SPFeedDetailCollaborationTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SPCommentsSmallTableViewCell", forIndexPath: indexPath) as! SPCommentsSmallTableViewCell
            cell.delegate = self
            
            //TODO: Refactor the photo pair model to consist of two individual entities
            var comments = []
            if self.imageTapped == ImageIdentifier.ImageTwo{
                comments = self.feedItem.comments.commentsPhotoTwo
            }
            if self.imageTapped == ImageIdentifier.ImageOne {
                comments = self.feedItem.comments.commentsPhotoOne
            }
            
            cell.setupCell(comments[indexPath.row - 2] as! SPActivity)
            return cell
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var comments = self.feedItem.comments.commentsPhotoTwo
        if self.imageTapped == ImageIdentifier.ImageOne {
            comments = self.feedItem.comments.commentsPhotoOne
        }

        return comments.count + 2 //for two static cells
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 382
        }
        else if(indexPath.row == 1){
            return 44
        }
        else{
            return 23
        }
        
    }
    
    func showAllComments() {
        var commentsViewController = SPCommentsViewController()
        commentsViewController.setup(self.feedItem, imageTapped:self.imageTapped)
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
    func likeButtonTapped() {
        println("Like Button Tapped")
    }
    
    func commentButtonTapped() {
        println("Comment Button Tapped")
        self.showAllComments()
    }
}
