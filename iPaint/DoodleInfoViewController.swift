//
//  DoodleInfoViewController.swift
//  iPaint
//
//  Created by Shukti Shaikh on 9/11/18.
//  Copyright © 2018 TShaikh. All rights reserved.
//

import Foundation
import UIKit

class DoodleInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var doodle: Doodle?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageData = doodle?.image
        image = UIImage(data: imageData! as Data)
        imageView.image = image
        
        self.navigationController?.navigationBar.tintColor = UIColor.MyTheme.redColor
        
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        if let image = image {
            shareAnImage(image: image)
        }
    }
    
    
    
}
