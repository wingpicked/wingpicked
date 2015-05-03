//
//  SPProfileEmptyFollowersView.swift
//  Stylpic
//
//  Created by Joshua Bell on 5/2/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

@objc protocol SPProfileEmptyFollowersViewDelegate {
    func findFriendsButtonDidTap()
}

class SPProfileEmptyFollowersView: UIView {
    weak var delegate :SPProfileEmptyFollowersViewDelegate?
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
