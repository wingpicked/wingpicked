//
//  SPFeedDetailViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 2/8/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPFeedDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var comments = ["Hello", "hahaha", "you look nice!"]
    lazy var inputAccessoryViewz : UIView = {
        var av = UIView()
        
            var accessFrame = CGRectMake(0, 0, self.view.frame.width, 77)
            av = UIView(frame: accessFrame)
            av.backgroundColor = UIColor.blueColor()
        
        return av
    }()

    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var imageFile : PFFile

    
    
    init(imageFile : PFFile){
        self.imageFile = imageFile
        super.init(nibName: "SPFeedDetailViewController", bundle: nil)
    }
    
//    override init() {
//        super.init(nibName: "SPFeedDetailViewController", bundle: nil)
//    }

    required init(coder aDecoder: NSCoder) {
        self.imageFile = PFFile() //TODO: Place default image here.
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.registerNib(UINib(nibName: "SPFeedDetailPictureTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailPictureTableViewCell")
        tableView.registerNib(UINib(nibName: "SPFeedDetailPictureTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailPictureTableViewCell")
        tableView.registerNib(UINib(nibName: "SPFeedDetailCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SPFeedDetailCommentTableViewCell")

        commentTextField.inputAccessoryView = self.inputAccessoryViewz
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //TODO: Refactor this to get a base cell or something out of here so there isn't duplicate code.
        if(indexPath.row == 0){
        let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailPictureTableViewCell", forIndexPath: indexPath) as! SPFeedDetailPictureTableViewCell
            cell.setupCell(imageFile)
            return cell
        }
        else {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPFeedDetailCommentTableViewCell", forIndexPath: indexPath) as! SPFeedDetailCommentTableViewCell
            
            cell.setupCell(comments[indexPath.row])
            return cell
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 382;
        }
        else{
            return 44;
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        comments.append(textField.text)
        self.tableView.reloadData()
        textField.resignFirstResponder()
        return true
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
