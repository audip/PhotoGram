//
//  PhotoCollectionCell.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 05/03/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var postedImageView: UIImageView!
    
    var post: Post! {
        didSet{
        
            let userImageFile = post.media!
            
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.postedImageView.image = UIImage(data:imageData)
                    }
                }
            }
        }
    }
}
