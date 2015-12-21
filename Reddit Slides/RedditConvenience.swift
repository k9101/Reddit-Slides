//
//  RedditConvenience.swift
//  Reddit Slides
//
//  Created by Kris Penney on 2015-12-20.
//  Copyright © 2015 Kris Penney. All rights reserved.
//

import Foundation

extension RedditClient {
    
    func getSubredditImages(subreddit: String, completionHandler: (imageUrls: [String]) -> Void){
        taskForGETMethod("\(subreddit)/.json", parameters: [:]) { (result, error) -> Void in
            if let error = error{
                print(error)
            }
            
            let data = result["data"] as! [String : AnyObject]
            let posts = data["children"] as! [AnyObject]
            var imageUrls = [String]()
            
            for post in posts{
                let postData = post["data"] as! [String : AnyObject]
                var url = postData["url"] as! String
                
                if url[url.endIndex.advancedBy(-4)] == "." {
                    if !url.containsString("https"){
                        url = url.stringByReplacingOccurrencesOfString("http", withString: "https")
                    }
                    imageUrls.append(url)
                    print(url)
                }
            }
            
            completionHandler(imageUrls: imageUrls)
        }
    }

}