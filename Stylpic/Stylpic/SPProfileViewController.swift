//
//  SPProfileViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPProfileViewController: UIViewController, UITabBarControllerDelegate, CommentInputAccessoryViewDelegate {

    @IBOutlet weak var commentView: CommentInputAccessoryView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapLikeButton() {
        println("Like")
    }
    
    func didTapSendButtonWithText(text: String) {
        println("Text")
    }
}
