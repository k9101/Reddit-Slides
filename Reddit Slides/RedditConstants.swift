//
//  RedditConstants.swift
//  Reddit Slides
//
//  Created by Kris Penney on 2015-12-20.
//  Copyright © 2015 Kris Penney. All rights reserved.
//

import Foundation

extension RedditClient {
    struct Constants {
        static let BaseURL = "https://www.reddit.com/r/"
    }
    
    struct Methods {
        static let SubReddits = [
            "Nature" : "earthporn",
            "Space" : "spaceporn",
            "Plants" : "botanicalporn",
            "Sky" :  "skyporn",
            "Fire" : "fireporn",
            "Machines" : "machineporn",
            "Cars" :  "carporn",
            "Boats" :  "boatporn",
            "Cities" :  "cityporn",
            "Villages" : "villageporn",
            "Architecture" :  "architectureporn",
            "Abandoned Structures" : "abandonedporn"
        ]
    }
    
}