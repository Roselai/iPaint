//
//  ViewController.swift
//  iPaint
//
//  Created by Shukti Shaikh on 9/10/18.
//  Copyright © 2018 TShaikh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var colorPickerButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        navigationController?.setToolbarHidden(false, animated: false)
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearCanvas(_ sender: Any) {
        canvasView.clearCanvas()
    }
    
    @IBAction func colorPickerPressed(_ sender:
        Any) {
       
  
    }

    

}

