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
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Load the data
    override func viewWillAppear(animated: Bool) {
        loadData()
    }
    
    //Stop the slideshow
    override func viewWillDisappear(animated: Bool) {
        timer.invalidate()
    }

    //Load the data from the user's selected subreddit, start slideshow
    func loadData(){
        let messageFrame = loadingViewFactory()
        
        var category = "Nature"
        
        if let userCategory = NSUserDefaults.standardUserDefaults().objectForKey("Category") {
            category = userCategory as! String
        }
        
        RedditClient.sharedInstance().getSubredditImages(RedditClient.Methods.SubReddits[category]!) { (imageUrls) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                self.imageUrls = imageUrls
                self.length = imageUrls.endIndex
                self.slideShow()
                messageFrame.removeFromSuperview()
            }
        }
    }
    
    //control slide show timing and looping
    func slideShow(){
        var current = 1
        displayImage(imageUrls[0])
        timer = NSTimer.schedule(repeatInterval: 15, handler: { (timer) -> Void in
            self.displayImage(self.imageUrls[current])
            current = (current + 1) % self.length
        })
    }
    
    // Load the given url image and load it into the imageCanvas
    func displayImage(url : String){
        RedditClient.sharedInstance().getDataFromUrl(NSURL(string: url)!) { (data, response, error) -> Void in
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

    
    //Generate a loading view
    func loadingViewFactory() -> UIView {
        let strLabel = UILabel(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        strLabel.text = "Fetching Photos"
        strLabel.textColor = UIColor.whiteColor()
        strLabel.font = UIFont(name: (strLabel.font?.fontName)!, size: 30)
        
        let messageFrame = UIView(frame: CGRect(x: view.frame.midX - 180, y: view.frame.midY - 50 , width: 360, height: 100))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)//UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        
        return messageFrame
    }
    
}

