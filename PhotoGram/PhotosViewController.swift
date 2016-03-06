//
//  PhotosViewController.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 28/02/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postList: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 320
        
        loadData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func loadData() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Post.fetchPostsWithCompletion { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                print("Successfully retrieved posts: \(objects!.count)")
                if let posts = objects {
                    self.postList = Post.postsWithArray(posts)
                }
                self.tableView.reloadData()
                
            } else {
                let errorString = error!.userInfo["error"] as? NSString
                print("Error message: \(errorString)")
            }
        }
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
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
        
        cell.post = postList![indexPath.row]
                
        return cell
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
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
