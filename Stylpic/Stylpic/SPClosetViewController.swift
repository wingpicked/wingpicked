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
    var pfFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "SPClosetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SPClosetCollectionViewCell")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "MyClosetTopBarTitle-Edit"), forBarMetrics: UIBarMetrics.Default)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SPManager.sharedInstance.getMyClosetItemsWithResultBlock { (somePFFiles, error) -> Void in
            if error != nil {
                println(error)
            } else {
                if let somePFFiles = somePFFiles {
                    self.pfFiles = somePFFiles
                    self.collectionView.reloadData()
                }
                
            }
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SPClosetCollectionViewCell", forIndexPath: indexPath) as! SPClosetCollectionViewCell
        cell.setupWithPFFile( pfFiles[indexPath.row] )
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pfFiles.count;
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
