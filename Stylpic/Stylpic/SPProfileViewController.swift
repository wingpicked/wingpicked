//
//  SPProfileViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPProfileViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        var tabBar = SPTabBarViewController()
        var closetVC = SPClosetViewController()
        tabBar.viewControllers = [closetVC]
//        tabBar.setViewControllers([closetVC], animated: true)
        tabBar.delegate = self
        
//        var z = tabBar.tabBar.items[2]

        
        self.view.addSubview(tabBar.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
