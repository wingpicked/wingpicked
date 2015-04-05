//
//  SPClosetDetailViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

protocol SPClosetDetailViewControllerDelegate:class {
    func removeClosetPhoto( closetPhoto: SPClosetPhoto )
    
}


class SPClosetDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var removeFromClosetButton: UIButton!
    weak var delegate:SPClosetDetailViewControllerDelegate?
    
    var closetPhoto : SPClosetPhoto?
    
    override func viewDidLoad() {
        if let closetPhoto = self.closetPhoto {
            self.imageView.file = closetPhoto.photo.photo
            self.imageView.loadInBackground(nil)
        }
    }
    
    @IBAction func removePicture(sender: AnyObject) {
        self.delegate?.removeClosetPhoto( self.closetPhoto! )
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupWithClosetPhoto( closetPhoto: SPClosetPhoto ) {
        self.closetPhoto = closetPhoto
    }
}
