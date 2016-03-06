//
//  SearchViewController.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 04/03/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredList: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = filteredList {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        cell.post = filteredList![indexPath.row]
        cell.selectionStyle = .None
        
        return cell
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var searchOptions = ["caption", "author"]
        let searchOption = searchOptions[searchSegmentedControl.selectedSegmentIndex]
        
        searchBar.resignFirstResponder()
        Post.searchPostsWithCompletion([searchOption: searchBar.text!.lowercaseString], completion: { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                print("Successfully searched posts: \(objects!.count)")
                if let posts = objects {
                    self.filteredList = Post.postsWithArray(posts)
                }
                self.tableView.reloadData()
                
            } else {
                let errorString = error!.userInfo["error"] as? NSString
                print("Error message: \(errorString)")
            }
            
        })
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
