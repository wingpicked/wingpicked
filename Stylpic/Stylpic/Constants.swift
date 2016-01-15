//
//  Constants.swift
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

let primaryAquaColor = UIColor(red: 0/255, green: 155/255, blue: 180/255, alpha: 1.0)
let secondaryAquaColor = UIColor(red: 76/255, green: 182/255, blue: 179/255, alpha: 1.0)
let navigationBarColor = UIColor(red: 182/255, green: 235/255, blue: 214/255, alpha: 1.0)

enum ImageIdentifier : Int {
    case ImageOne
    case ImageTwo
    
}

enum ActivityType : Int {
    case CommentImageOne
    case CommentImageTwo
    case LikeImageOne
    case LikeImageTwo
    case Follow
    case Join
    
}

struct SPGlobalNotifications {
    static let SPViewModelsNeedsRefresh = "SPModelNeedsRefresh"
}


class Constants: NSObject {
   
}
