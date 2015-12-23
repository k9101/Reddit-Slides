//
//  SecondViewController.swift
//  Reddit Slides
//
//  Created by Kris Penney on 2015-12-20.
//  Copyright © 2015 Kris Penney. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataSource: [String] = []
    
    @IBOutlet var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        //Generate categories
        for (key, _) in RedditClient.Methods.SubReddits {
            dataSource.append(key)
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Category Cell")!

        cell.textLabel!.text = dataSource[indexPath.row]
        
        return cell
    }
    
    //Update defaults to new choice
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSUserDefaults.standardUserDefaults().setObject(dataSource[indexPath.row], forKey: "Category")
    }
}

