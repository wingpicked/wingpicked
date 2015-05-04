//
//  SPPhotoConfirmationViewController.swift
//  Stylpic
//
//  Created by Joshua Bell on 5/3/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

@objc protocol SPPhotoConfirmationViewControllerDelegate {
    func nextSendButtonDidTap()
    func nextCameraButtonDidTap()
    func confirmationBackButtonDidTap()
}

class SPPhotoConfirmationViewController: UIViewController {
    @IBOutlet weak var nextSendButton: UIButton!
    @IBOutlet weak var nextCameraButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var photo: UIImageView!
    weak var delegate:SPPhotoConfirmationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonDidTap(sender: AnyObject) {
        self.delegate?.confirmationBackButtonDidTap()
    }

    @IBAction func nextSendButtonDidTap(sender: AnyObject) {
        self.delegate?.nextSendButtonDidTap()
    }
    
    @IBAction func nextCameraButtonDidTap(sender: AnyObject) {
        self.delegate?.nextCameraButtonDidTap()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

}
