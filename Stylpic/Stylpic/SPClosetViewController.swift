//
//  SPClosetViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPClosetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "SPClosetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SPClosetCollectionViewCell")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "MyClosetTopBarTitle-Edit"), forBarMetrics: UIBarMetrics.Default)
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SPClosetCollectionViewCell", forIndexPath: indexPath) as! SPClosetCollectionViewCell
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        
        var detailViewController = SPClosetDetailViewController(nibName: "SPClosetDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "didSelectCell"){
//            segue.
//            segue.destinationViewController 
//        }
//    }
}
