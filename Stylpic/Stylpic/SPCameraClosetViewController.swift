//
//  SPCameraClosetViewController.swift
//  Stylpic
//
//  Created by Joshua Bell on 5/3/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

@objc protocol SPCameraClosetViewControllerDelegate {
    func userSelectedImage( image: UIImage )
    
}

class SPCameraClosetViewController: SPClosetViewController {

    weak var delegate:SPCameraClosetViewControllerDelegate?
    
    init() {
        super.init(nibName: "SPCameraClosetViewController", bundle: nil)
//        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView.frame = self.view.frame;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if let closetPhotos = self.closetPhotos {
            let closetPhoto = closetPhotos[indexPath.row]
            var data: NSData?
            do {
               data = try closetPhoto.photo.photo.getData()
            } catch {
                print( error )
            }
            
            if let data = data {
                self.delegate?.userSelectedImage(UIImage(data: data)!)
            }
        }
    }
}
