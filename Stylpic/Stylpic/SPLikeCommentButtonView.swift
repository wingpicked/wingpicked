//
//  SPLikeCommentButtonView.swift
//  Stylpic
//
//  Created by Neil Bhargava on 4/5/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPLikeCommentButtonViewDelegate {
    func likeButtonTapped()
    func commentButtonTapped()
}

class SPLikeCommentButtonView: UIView {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!

    var delegate : SPLikeCommentButtonViewDelegate?
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        self.delegate?.likeButtonTapped()
    }

    @IBAction func commentButtonTapped(sender: AnyObject) {
        self.delegate?.commentButtonTapped()
    }
}
