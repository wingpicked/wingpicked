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

    var delegate : SPLikeCommentButtonViewDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func likeButtonTapped(sender: AnyObject) {
        self.delegate?.likeButtonTapped()
    }

    @IBAction func commentButtonTapped(sender: AnyObject) {
        self.delegate?.commentButtonTapped()
    }
}
