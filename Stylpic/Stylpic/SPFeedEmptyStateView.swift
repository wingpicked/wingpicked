//
//  SPFeedEmptyStateView.swift
//  Stylpic
//
//  Created by Joshua Bell on 4/27/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

@objc protocol SPFeedEmptyStateViewDelegate {
    func findFriendsButtonDidTap()
}

class SPFeedEmptyStateView: UIView {
    
    var delegate: SPFeedEmptyStateViewDelegate?
    
    @IBOutlet weak var findFriendsButton: UIButton!

    @IBAction func findFriendsButtonDidTap(sender: UIButton) {
        self.delegate?.findFriendsButtonDidTap()
    }
    
}
