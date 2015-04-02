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
    var pfFiles : [PFFile]? //= [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "SPClosetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SPClosetCollectionViewCell")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "MyClosetTopBarTitle-Edit"), forBarMetrics: UIBarMetrics.Default)
        
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

//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SPClosetCollectionViewCell", forIndexPath: indexPath) as! SPClosetCollectionViewCell
        
        if let pfFiles = pfFiles {
            cell.setupWithPFFile( pfFiles[indexPath.row] )
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pfFiles != nil ? pfFiles!.count : 0;
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        
        var detailViewController = SPClosetDetailViewController(nibName: "SPClosetDetailViewController", bundle: nil)

    
        if let pfFiless = pfFiles{
            println(pfFiless.count)
            //detailViewController.imageView.file = pfFiles![indexPath.row];
                self.navigationController?.pushViewController(detailViewController, animated: true)
        }
        
    }
    
}
