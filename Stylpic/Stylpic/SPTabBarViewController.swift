//
//  SPTabBarViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPTabBarViewController: UITabBarController, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
        if self.viewControllers != nil {
            for viewController in self.viewControllers as! [UIViewController] {
                var view = viewController.view;
            }
        }
    }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

//        if((viewControllers as! [UIViewController])[2] == viewController){
//            self.prompTo()
//            return false
//        }
        return true
    }
    
}
