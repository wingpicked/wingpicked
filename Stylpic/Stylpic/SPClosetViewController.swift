//
//  SPClosetViewController.swift
//  Stylpic
//
//  Created by Neil Bhargava on 1/13/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

class SPClosetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SPClosetDetailViewControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var closetPhotos : [SPClosetPhoto]? //= [PFFile]()
    var lastTappedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "SPClosetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SPClosetCollectionViewCell")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "MyClosetTopBarTitle-Edit"), forBarMetrics: UIBarMetrics.Default)
        
        SPManager.sharedInstance.getMyClosetItemsWithResultBlock { (someClosetPhotos, error) -> Void in
            if error != nil {
                println(error)
            } else {
                if let someClosetPhotosAgain = someClosetPhotos {
                    self.closetPhotos = someClosetPhotosAgain
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
        
        if let closetPhotos = self.closetPhotos {
            let closetPhoto = closetPhotos[indexPath.row]
            let aFile = closetPhoto.photo.photoThumbnail
            cell.setupWithPFFile( aFile )
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.closetPhotos != nil ? self.closetPhotos!.count : 0;
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        self.lastTappedRow = indexPath.row
//        var detailViewController = SPClosetDetailViewController( aPFFile: self.pfFiles![indexPath.row] )
//        self.navigationController?.pushViewController(detailViewController, animated: true)
        self.performSegueWithIdentifier("SPClosetDetailViewController", sender: self);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Make sure your segue name in storyboard is the same as this line
        if segue.identifier == "SPClosetDetailViewController" {
            // Get reference to the destination view controller
            let viewController = segue.destinationViewController as! SPClosetDetailViewController
            
            // Pass any objects to the view controller here, like...
            let closetPhoto = self.closetPhotos![self.lastTappedRow]
            viewController.delegate = self
            viewController.setupWithClosetPhoto( closetPhoto )
        }
    }
    
    func removeClosetPhoto( closetPhoto: SPClosetPhoto ) {
        var indexToRemove = -1
        for var i = self.closetPhotos!.count - 1; i >= 0; --i {
            var aClosetPhoto = self.closetPhotos![ i ]
            if aClosetPhoto.objectId == closetPhoto.objectId {
                indexToRemove = i
                break
            }
        }
        
        if indexToRemove >= 0 {
            self.closetPhotos?.removeAtIndex( indexToRemove )
            SPManager.sharedInstance.removeClosetPhoto( closetPhoto )
            self.collectionView.reloadData()
        }
    }

}
