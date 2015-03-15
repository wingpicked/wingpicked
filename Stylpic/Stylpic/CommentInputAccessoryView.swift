//
//  CommentInputAccessoryView.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/12/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didTapSendButtonWithText(text: String)
    func didTapLikeButton()
}

class CommentInputAccessoryView: UIView, UITextFieldDelegate {

    var placeholderText = "Add Comment Here..."
    var leftImageForButton = UIImage(named: "Button_like_selected")
    var rightTextForButton = "Send"
    var delegate : CommentInputAccessoryViewDelegate?
    
    override func layoutSubviews() {
        
        var frame = self.frame
        var likeButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        likeButton.frame = CGRectMake(8, 16, 24, 24)
        likeButton.setImage(leftImageForButton, forState: UIControlState.Normal)
        likeButton.targetForAction(Selector("didTapLikeButton:"), withSender: self)
        likeButton.addTarget(self, action: Selector("didTapLikeButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(likeButton)
        
        var textField = UITextField(frame: CGRectMake(40, 10, 228, 30))
        
        textField.backgroundColor = UIColor.whiteColor()
        textField.placeholder = placeholderText
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.inputAccessoryView = CommentInputAccessoryView()
        
        self.addSubview(textField)
        
        var sendMessageButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        sendMessageButton.frame = CGRectMake(276, 10, 36, 30)
        sendMessageButton.setTitle(rightTextForButton, forState: .Normal)
        sendMessageButton.titleLabel?.font = UIFont(name: "OpenSans", size: 8.0)
        sendMessageButton.backgroundColor = UIColor.darkGrayColor()
        sendMessageButton.addTarget(self, action: Selector("didTapSendButtonWithText:"), forControlEvents: .TouchUpInside)
        self.addSubview(sendMessageButton)
    }
    
    func didTapSendButtonWithText(sender: AnyObject){
        self.delegate?.didTapSendButtonWithText("hi")
    }
    func didTapLikeButton(sender: AnyObject){
        self.delegate?.didTapLikeButton()
    }
    
}
