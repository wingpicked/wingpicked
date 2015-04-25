//
//  Constants.swift
//  Stylpic
//
//  Created by Joshua Bell on 3/22/15.
//  Copyright (c) 2015 Neil Bhargava. All rights reserved.
//

import UIKit

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
