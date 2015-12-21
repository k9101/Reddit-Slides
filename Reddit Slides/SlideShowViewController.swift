//
//  FirstViewController.swift
//  Reddit Slides
//
//  Created by Kris Penney on 2015-12-20.
//  Copyright © 2015 Kris Penney. All rights reserved.
//

import UIKit

class SlideShowViewController: UIViewController {
    @IBOutlet weak var imageCanvas: UIImageView!

    var imageUrls: [String]!
    var length = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        RedditClient.sharedInstance().getSubredditImages("carporn") { (imageUrls) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                self.imageUrls = imageUrls
                self.length = imageUrls.endIndex
                self.slideShow()
            }
        }
    }

    func slideShow(){
        var current = 1
        displayImage(0)
        NSTimer.schedule(repeatInterval: 7, handler: { (timer) -> Void in
            self.displayImage(current)
            current = (current + 1) % self.length
        })
    }
    
    func displayImage(i : Int){
        RedditClient.sharedInstance().getDataFromUrl(NSURL(string: imageUrls[i])!) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return}
                
                UIView.transitionWithView(self.imageCanvas, duration: 2,
                    options: UIViewAnimationOptions.TransitionCrossDissolve,
                    animations: {
                        self.imageCanvas.image = UIImage(data: data)
                    },
                    completion: nil)
            }
        }
        
    }


}

