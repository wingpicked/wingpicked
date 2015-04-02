//
//  SPCamera2ViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/1/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Parse

class SPCamera2ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{

    //var cameraUI = UIImagePickerController()//: UIImagePickerController!
    var navController = UINavigationController()
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    

    @IBAction func logoutButtonTouchUpInside(sender: AnyObject) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
