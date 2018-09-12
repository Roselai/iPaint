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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageData = doodle?.image
        let image = UIImage(data: imageData! as Data)
        imageView.image = image
    }
    
}
