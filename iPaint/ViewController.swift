//
//  ViewController.swift
//  iPaint
//
//  Created by Tabassum Shaikh on 9/10/18.
//  Copyright © 2018 TShaikh. All rights reserved.
//

import UIKit
import ChromaColorPicker
import CoreData

class ViewController: UIViewController, ChromaColorPickerDelegate, ChromaShadeSliderDelegate {
    
    // MARK: OUTLETS
    @IBOutlet weak var clearCanvasButton: UIBarButtonItem!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var colorPickerButton: UIBarButtonItem!
    @IBOutlet weak var lineWidthSlider: UISlider!
    @IBOutlet weak var brushSizeButton: UIBarButtonItem!
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    var managedContext: NSManagedObjectContext!
    
    // MARK: VARIABLES
    var colorPicker = ChromaColorPicker()
    var currentColor: UIColor = .black
    
    
    
    // MARK: VIEW FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.setToolbarHidden(false, animated: false)
        clearCanvasButton.isEnabled = false
        colorPickerButton.tintColor = currentColor
        brushSizeButton.title = "Brush Size: \( Int(lineWidthSlider.value))"
        lineWidthSlider.isHidden = true
        
        setupSlider()
        setupColorPickerView()
        
        managedContext = persistentContainer.viewContext
        
        //Notifies the viewcontroller if the user has started to draw on the canvas and a path exists
        NotificationCenter.default.addObserver(self, selector: #selector(onPathExists(_:)), name: .pathExists, object: nil)
        
    }
    
    // MARK: NOTIFICATION RESPONSE FUNCTION
    @objc func onPathExists(_ notification:Notification) {
        clearCanvasButton.isEnabled = true
    }
    
    
    // MARK: INTERFACE BUILDER FUNCTIONS
    
    @IBAction func clearCanvas(_ sender: Any) {
        
        canvasView.clearCanvas()
        clearCanvasButton.isEnabled = false
        
    }
    
    @IBAction func colorPickerPressed(_ sender:
        Any) {
        
        colorPicker.isHidden = false
        canvasView.isHidden = true
    }
    
    @IBAction func setAsBGColorPressed(_ sender: UIBarButtonItem) {
        canvasView.backgroundColor = currentColor
        clearCanvasButton.isEnabled = true
    }
    
    @IBAction func lineWidthSliderValueChanged(_ sender: UISlider) {
        let width = sender.value
        canvasView.lineWidth = CGFloat(width)
        brushSizeButton.title = "Brush Size: \( Int(width))"
    }
    
    @IBAction func brushSizeButtonPressed(_ sender: UIBarButtonItem) {
        toggleSlider()
    }
    
    
    @IBAction func savedImagesViewPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "showSavedImages", sender: self)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let imageToSave = generateImage()
        save(image: imageToSave)
        
    }
    
    @IBAction func shareImage(sender: UIBarButtonItem) {
        // image to share
        let image = generateImage()
        
        shareAnImage(image: image)
        
    }
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSavedImages" {
            
            let destinationVC = segue.destination as! SavedImagesViewController
            destinationVC.persistentContainer = persistentContainer
            destinationVC.managedContext = managedContext
            
        }
    }
    
    
    
    // MARK: COLORPICKER DELEGATE FUNCTIONS
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        colorPicker.isHidden = true
        canvasView.isHidden = false
        currentColor = color
        canvasView.lineColor = currentColor
        colorPickerButton.tintColor = currentColor
    }
    
    func shadeSliderChoseColor(_ slider: ChromaShadeSlider, color: UIColor) {
        colorPicker.isHidden = true
        canvasView.isHidden = false
        currentColor = color
        canvasView.lineColor = currentColor
        colorPickerButton.tintColor = currentColor
    }
    
    // MARK: SAVE IMAGE FUNCTIONS
    
    func generateImage() -> UIImage {
        
        hideToolBars(flag: true)
        lineWidthSlider.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolBars(flag: false)
        
        return image
    }
    
    
    func save(image: UIImage) {
        
        let date = Date() as NSDate
        let uuID = UUID()
        let imageData = image.png
        
        persistentContainer.performBackgroundTask() { (context) in
            let doodle = Doodle(context: context)
            doodle.creationDate = date
            doodle.id = uuID
            doodle.image = imageData
            
            self.saveContext(context: context)
        }
        
        
        
        /*UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)*/
    }
    
    func saveContext (context: NSManagedObjectContext){
        do {
            try context.save()
            let ac = UIAlertController(title: "Saved!", message: "Your drawing has been saved.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } catch let error as NSError {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    /*
     @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
     
     if let error = error {
     let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default))
     present(ac, animated: true)
     } else {
     let ac = UIAlertController(title: "Saved!", message: "Your drawing has been saved to your photos.", preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default))
     present(ac, animated: true)
     }
     }*/
    
    
    
    // MARK: VIEW/TOOLBARS/ELEMENTS SETUP FUNCTIONS
    
    fileprivate func setupColorPickerView() {
        let width: CGFloat = 300
        let height: CGFloat = 300
        colorPicker = ChromaColorPicker(frame: CGRect(x: (self.view.frame.width/2) - width/2 , y: (self.view.frame.height/2) - height/2 , width: width, height: height))
        colorPicker.isHidden = true
        colorPicker.delegate = self
        colorPicker.supportsShadesOfGray = true
        colorPicker.hexLabel.isHidden = true
        colorPicker.adjustToColor(currentColor)
        view.addSubview(colorPicker)
    }
    
    fileprivate func setupSlider () {
        
        let w = view.bounds.width
        let h = view.bounds.height
        let y = h/2
        let x = w - 30
        lineWidthSlider.bounds.size.width = w
        lineWidthSlider.center = CGPoint(x: x , y: y )
        lineWidthSlider.transform = CGAffineTransform(rotationAngle: (CGFloat(3*Double.pi/2)))
        lineWidthSlider.backgroundColor = .clear
        lineWidthSlider.isHidden = true
        view.addSubview(lineWidthSlider)
        
    }
    
    func hideToolBars(flag:Bool){
        navigationController?.setToolbarHidden(flag, animated: false)
        navigationController?.navigationBar.isHidden = flag
        
    }
    
    func toggleSlider() {
        if lineWidthSlider.isHidden == true {
            lineWidthSlider.isHidden = false
        } else {
            lineWidthSlider.isHidden = true
        }
    }
    
    
}

extension UIImage {
    var jpeg: NSData? {
        return UIImageJPEGRepresentation(self, 1)! as NSData   // QUALITY min = 0 / max = 1
    }
    var png: NSData? {
        return UIImagePNGRepresentation(self)! as NSData
    }
}

extension UIViewController {
    
    func shareAnImage(image: UIImage){
        let imageToShare = [image]
        presentActivityViewController(imageToShare: imageToShare)
    }
    
    func presentActivityViewController(imageToShare: [UIImage]){
    let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}




