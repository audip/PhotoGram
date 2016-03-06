//
//  PhotoCell.swift
//  PhotoGram
//
//  Created by Aditya Purandare on 04/03/16.
//  Copyright © 2016 Aditya Purandare. All rights reserved.
//

import UIKit
import Parse

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post! {
        didSet{
    
            handleLabel.text = "@\(post.author!)"
            captionLabel.text = post.caption!
            timestampLabel.text = "\(post.timestamp!)"
            
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
