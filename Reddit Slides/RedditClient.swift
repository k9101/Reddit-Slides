//
//  RedditClient.swift
//  Reddit Slides
//
//  Created by Kris Penney on 2015-12-20.
//  Copyright © 2015 Kris Penney. All rights reserved.
//

import Foundation

class RedditClient : NSObject{
    
    var session: NSURLSession
    var config: NSObject
    
    override init() {
        session = NSURLSession.sharedSession()
        config = NSObject()
        super.init()
    }
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error : NSError?) -> Void) -> NSURLSessionDataTask{
        
        let urlString = Constants.BaseURL + method + APIHelpers.escapedParameters(parameters)
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            APIHelpers.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
        
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        session.dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> RedditClient {
        
        struct Singleton {
            static var sharedInstance = RedditClient()
        }
        
        return Singleton.sharedInstance
    }
    
}