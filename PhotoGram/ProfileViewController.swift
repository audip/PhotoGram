//
//  ProfileViewController.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 03/03/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var postList: [Post]?
    var user: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        if user == nil {
            user = PFUser.currentUser()?.username!
        }
        
        nameLabel.text = user!
        
        Post.loadProfileImageWithCompletion(["username": user!], completion: { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                print("Load user profile: \(objects!.count)")
                for object in objects! {
                    if let userImageFile = object["media"] as? PFFile {
                        userImageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    self.profileImageView.image = UIImage(data:imageData)
                                }
                            }
                        }
                    } else {
                        self.profileImageView.image = UIImage(named: "default")
                    }
                }
            } else {
                let errorString = error!.userInfo["error"] as? NSString
                print("Error message: \(errorString)")
            }
        })
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Post.searchPostsWithCompletion(["author": user!.lowercaseString], completion: { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                print("Successfully loaded posts: \(objects!.count)")
                if let posts = objects {
                    self.postList = Post.postsWithArray(posts)
                }
                self.collectionView.reloadData()
                
            } else {
                let errorString = error!.userInfo["error"] as? NSString
                print("Error message: \(errorString)")
            }
        })
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = postList {
            return posts.count
        } else {
            return 0
        }
    }
    @IBAction func onChangeProfilePicture(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let customSize = CGSize(width: 240, height: 240)
        let finalImage = resize(editedImage, newSize: customSize)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        
        //Push image to Parse
        
        self.profileImageView.image = finalImage
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionCell", forIndexPath: indexPath) as! PhotoCollectionCell
        
        cell.post = postList![indexPath.row]
        
        return cell
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
