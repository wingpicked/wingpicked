//
//  SPProfileToolBar.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/15/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPProfileToolBarViewDelegate {
    func postsButtonTapped()
    func followersButtonTapped()
    func followingButtonTapped()
    func notificationsButtonTapped()
}

class SPProfileToolBarView: UIView {
    

    @IBOutlet weak var postsButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!

    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    
    
    var delegate : SPProfileToolBarViewDelegate?

    @IBAction func postsButtonTapped(sender: AnyObject) {
        self.delegate?.postsButtonTapped()
    }
    @IBAction func followersButtonTapped(sender: AnyObject) {
        self.delegate?.followersButtonTapped()
    }
    @IBAction func followingButtonTapped(sender: AnyObject) {
        self.delegate?.followingButtonTapped()
    }
    @IBAction func notificationsButtonTapped(sender: AnyObject) {
        self.delegate?.notificationsButtonTapped()
    }
}
