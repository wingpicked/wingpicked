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
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.loadInBackground(nil)
        //self.automaticallyAdjustsScrollViewInsets = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func removePicture(sender: AnyObject) {
    }
}
