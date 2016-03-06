//
//  Post.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 03/03/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    var author: String?
    var timestamp: String?
    var commentsCount: Int?
    var likesCount: Int?
    var caption: String?
    var media: PFFile?
    
    init(object: PFObject) {
        super.init()
        
        media = object["media"] as? PFFile
        caption = object["caption"] as? String
        author = object["author"] as? String
        let timeStamp = object["timestamp"] as? String
        commentsCount = object["commentsCount"] as? Int
        likesCount = object["likesCount"] as? Int
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let createdAt = formatter.dateFromString(timeStamp!)
        timestamp = "\(convertTimeToString(Int(NSDate().timeIntervalSinceDate(createdAt!))))"
    }
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser()?.username // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post["timestamp"] = "\(NSDate())"
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
        
    }
    
    class func postsWithArray(array: [PFObject]) -> [Post] {
        var posts = [Post]()
        for element in array {
            posts.append(Post(object: element))
        }
        return posts
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    class func fetchPostsWithCompletion(completion completion:([PFObject]?, NSError?) -> ()) {
        let query = PFQuery(className: "Post")
        query.orderByDescending("timestamp")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completion)
    }
    class func loadProfileImageWithCompletion(params: NSDictionary, completion:([PFObject]?, NSError?) -> ()) {
        let obj = params
        var userName: String?
        for (key, value) in obj {
            userName = value as? String
        }
        print(userName!)
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName!)
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completion)
    }
    class func searchPostsWithCompletion(params: NSDictionary, completion:([PFObject]?, NSError?) -> ()) {
        let obj = params
        var searchKey: String?
        var searchValue: String?
        for (key, value) in obj {
            searchKey = key as? String
            searchValue = value as? String
        }
        print("Key: \(searchKey!), Value: \(searchValue!)")
        let query = PFQuery(className: "Post")
        query.whereKey(searchKey!, containsString: searchValue!)
        query.orderByDescending("timestamp")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completion)
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

}