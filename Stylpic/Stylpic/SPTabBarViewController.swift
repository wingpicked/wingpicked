//
//  SPTabBarViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit
import Social

class SPTabBarViewController: UITabBarController, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
    }

//    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//
////        if((viewControllers as! [UIViewController])[2] == viewController){
////            self.prompTo()
////            return false
////        }
//        return true
//    }
    
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if((self.viewControllers as! [UIViewController])[3] == viewController){
            var profileViewController = (viewController as! UINavigationController).viewControllers[0] as! SPProfileViewController
            profileViewController.showWithUser( SPUser.currentUser() )            
        }
    }

}
