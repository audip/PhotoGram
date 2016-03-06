//
//  LibraryViewController.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 04/03/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import MBProgressHUD

class LibraryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    
    var finalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.captionTextField.delegate = self
        
    }
    func imagePickerController(picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let customSize = CGSize(width: 520, height: 520)
        self.finalImage = resize(editedImage, newSize: customSize)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        self.previewImageView.image = editedImage
    }

    @IBAction func selectPhoto(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func onUpload(sender: AnyObject) {
        
        
        var caption = captionTextField.text
        
        let spinningCompleted = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningCompleted.labelText = "Uploading..."
        spinningCompleted.userInteractionEnabled = false
        
        if caption == nil {
            caption = "A beautiful photo"
        }
        
        Post.postUserImage(finalImage, withCaption: caption) { (success: Bool, error: NSError?) in
            
            if success {
                print("Image uploaded succesfully")
                //spinningCompleted.hide(true, afterDelay: 2)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        captionTextField.resignFirstResponder()
        return true;
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
