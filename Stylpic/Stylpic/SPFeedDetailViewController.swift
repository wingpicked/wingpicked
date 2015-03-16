//
//  SPFeedDetailViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 2/8/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit


class SPFeedDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var commentInputAccessoryView: CommentInputAccessoryView!
//    var comments = ["Hello", "hahaha", "you look nice!"]
    lazy var inputAccessoryViewz : UIView = CommentInputAccessoryView()

    //@IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var imageFile : PFFile
    var feedItem: SPFeedItem
    var imageTapped : ImageIdentifier
    
    init(feedItem : SPFeedItem, imageTapped: ImageIdentifier) {
        self.imageTapped = imageTapped
        self.feedItem = feedItem
        
        
        var imageTapedKey = "imageTwo"
        if imageTapped == ImageIdentifier.ImageOne {
            imageTapedKey = "imageOne"
        }
        
        self.imageFile = self.feedItem.photos?.objectForKey(imageTapedKey) as! PFFile
        super.init(nibName: "SPFeedDetailViewController", bundle: nil)
    }
    
//    override init() {
//        super.init(nibName: "SPFeedDetailViewController", bundle: nil)
//    }

    required init(coder aDecoder: NSCoder) {
        self.imageFile = PFFile() //TODO: Place default image here.
        self.feedItem = SPFeedItem()
        self.imageTapped = ImageIdentifier.ImageOne
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.registerNib(UINib(nibName: "SPFeedDetailPictureTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailPictureTableViewCell")
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailPictureTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailPictureTableViewCell")
        self.tableView.registerNib(UINib(nibName: "SPFeedDetailCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCommentTableViewCell")

        
        //commentTextField.inputAccessoryView = self.inputAccessoryViewz
    }

//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear( animated)
//        self.tableView.reloadData()
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //TODO: Refactor this to get a base cell or something out of here so there isn't duplicate code.
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailPictureTableViewCell", forIndexPath: indexPath) as! SPFeedDetailPictureTableViewCell
            cell.setupCell(imageFile)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailCommentTableViewCell", forIndexPath: indexPath) as! SPFeedDetailCommentTableViewCell
            var comments = self.feedItem.comments.commentsPhotoTwo
            if self.imageTapped == ImageIdentifier.ImageOne {
                comments = self.feedItem.comments.commentsPhotoOne
            }
            
            cell.setupCell(comments[indexPath.row - 1])
            return cell
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var comments = self.feedItem.comments.commentsPhotoTwo
        if self.imageTapped == ImageIdentifier.ImageOne {
            comments = self.feedItem.comments.commentsPhotoOne
        }

        return comments.count + 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 382;
        }
        else{
            return 44;
        }
        
    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool { posting a comment happens in the comment view
////        comments.append(textField.text)
//        self.tableView.reloadData()
//        textField.resignFirstResponder()
//        return true
//    }
    
    @IBAction func addComment(sender: AnyObject) {
        var commentsViewController = SPCommentsViewController()
        commentsViewController.setup(self.feedItem, imageTapped:self.imageTapped)
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    //Lazy load input accessory view

    //    - (UIView *)inputAccessoryView {
//    if (!inputAccessoryView) {
//    CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 77.0);
//    inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
//    inputAccessoryView.backgroundColor = [UIColor blueColor];
//    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    compButton.frame = CGRectMake(313.0, 20.0, 158.0, 37.0);
//    [compButton setTitle: @"Word Completions" forState:UIControlStateNormal];
//    [compButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [compButton addTarget:self action:@selector(completeCurrentWord:)
//    forControlEvents:UIControlEventTouchUpInside];
//    [inputAccessoryView addSubview:compButton];
//    }
//    return inputAccessoryView;
//    }
}
