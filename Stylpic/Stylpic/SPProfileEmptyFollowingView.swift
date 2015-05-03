//
//  SPProfileEmptyFollowingView.swift
//  Stylpic
//
//  Created by Joshua Bell on 5/2/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
@objc protocol SPProfileEmptyFollowingViewDelegate {
    
    func findFriendsButtonDidTap();
}
class SPProfileEmptyFollowingView: UIView {
    weak var delegate: SPProfileEmptyFollowingViewDelegate?
    @IBOutlet weak var button: UIButton!
    @IBAction func buttonDidTap(sender: AnyObject) {
        
        self.delegate?.findFriendsButtonDidTap()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
