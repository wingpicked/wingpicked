//
//  SPClosetDetailViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 3/4/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPClosetDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var removeFromClosetButton: UIButton!
    
    var closetPhoto : SPClosetPhoto?
    
    override func viewDidLoad() {
        if let closetPhoto = self.closetPhoto {
            self.imageView.file = closetPhoto.photo.photo
            self.imageView.loadInBackground(nil)
        }
    }
    
    @IBAction func removePicture(sender: AnyObject) {
        
    }
    
    func setupWithClosetPhoto( closetPhoto: SPClosetPhoto ) {
        self.closetPhoto = closetPhoto
    }
}
