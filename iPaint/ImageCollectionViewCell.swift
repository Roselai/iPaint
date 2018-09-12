//
//  ImageCollectionViewCell.swift
//  iPaint
//
//  Created by Shukti Shaikh on 9/11/18.
//  Copyright © 2018 TShaikh. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
         
            imageView.image = imageToDisplay
            
        } else {
          
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5
        
        update(with: nil)
        
    }
}
