//
//  PhotosViewController.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 28/02/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import Parse

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postList: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 320
        
        loadData()
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func loadData() {
        Post.fetchPostsWithCompletion { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                print("Successfully retrieved posts: \(objects!.count)")
                if let posts = objects {
                    self.postList = posts
                    for post in posts {
//                        print("Date: \(post["timestamp"])")
                        //print("Message: \(post) + User: \(post["caption"])")
                    }
                }
                self.tableView.reloadData()
                
            } else {
                let errorString = error!.userInfo["error"] as? NSString
                print("Error message: \(errorString)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = postList {
            return posts.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let author = postList![indexPath.row]["author"] as? String
        cell.handleLabel.text = "@\(author!)"
        cell.captionLabel.text = postList![indexPath.row]["caption"] as? String
        let timeStamp = postList![indexPath.row]["timestamp"] as? String
        //print("Date: \(postList![indexPath.row]["timestamp"])")

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let createdAt = formatter.dateFromString(timeStamp!)
        //print("\(createdAt)")
        
        if let timestamp = createdAt {
            cell.timestampLabel.text = "\(convertTimeToString(Int(NSDate().timeIntervalSinceDate(timestamp))))"
            //print(timestamp)
        }

        let userImageFile = postList![indexPath.row]["media"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.postedImageView.image = UIImage(data:imageData)
                }
            }
        }
        
        return cell
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
    }
    
    func convertTimeToString(number: Int) -> String{
        let day = number/86400
        let hour = (number - day * 86400)/3600
        let minute = (number - day * 86400 - hour * 3600)/60
        if day != 0{
            return String(day) + "d"
        }else if hour != 0 {
            return String(hour) + "h"
        }else{
            return String(minute) + "m"
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
    
        loadData()
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
