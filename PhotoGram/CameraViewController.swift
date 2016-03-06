//
//  CameraViewController.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 03/03/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import MobileCoreServices


class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        let vc = UIImagePickerController()
//        vc.delegate = self
//        vc.allowsEditing = true
//        vc.sourceType = UIImagePickerControllerSourceType.Camera
//        
//        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController

        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
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
