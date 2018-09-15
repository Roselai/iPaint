//
//  SavedImagesViewController.swift
//  iPaint
//
//  Created by Shukti Shaikh on 9/11/18.
//  Copyright © 2018 TShaikh. All rights reserved.
//


import UIKit
import CoreData

class SavedImagesViewController: UIViewController {
    
   
    
    // MARK: - properties
    var persistentContainer: NSPersistentContainer!
    var doodle: Doodle?
    var allDoodles: [Doodle] = []
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Doodle>!
    
    var insertedCache: [IndexPath]!
    var deletedCache: [IndexPath]!
    var updatedCache: [IndexPath]!
    var selectedCache = [IndexPath]()
    
    var selectedIndex: Int?
    var indexPathOfSelectedCell: IndexPath?
    var deleteButton: UIBarButtonItem?
    var showImageButton: UIBarButtonItem?
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImagesLabel: UILabel!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton = UIBarButtonItem(image: UIImage(named: "DeleteImageIcon"),
                                           style: UIBarButtonItemStyle.plain,
                                           target: self,
                                           action: #selector(SavedImagesViewController.deleteButtonClicked(sender:)))
        
        
        showImageButton = UIBarButtonItem(image: UIImage(named: "ShowImageIcon"),
                                           style: UIBarButtonItemStyle.plain,
                                           target: self,
                                           action: #selector(SavedImagesViewController.showImageButtonClicked(sender:)))
        
        deleteButton?.tintColor = UIColor.MyTheme.redColor
        showImageButton?.tintColor = UIColor.MyTheme.redColor
        self.navigationController?.navigationBar.tintColor = UIColor.MyTheme.redColor
        self.navigationItem.rightBarButtonItems = [deleteButton, showImageButton] as? [UIBarButtonItem]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        
        
        let fetchRequest: NSFetchRequest<Doodle> = Doodle.fetchRequest()
        fetchRequest.fetchBatchSize = 18
    
        let dateSort = NSSortDescriptor(key: #keyPath(Doodle.creationDate), ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        doFetch()
        
    }
    
    fileprivate func enableLableCheck() {
        if (fetchedResultsController.fetchedObjects?.count)! > 0 {
            noImagesLabel.isHidden = true
        } else {
            noImagesLabel.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showImageButton?.isEnabled = false
        deleteButton?.isEnabled = false
        
        enableLableCheck()
        
        collectionView.reloadData()
    }
    
    @objc func deleteButtonClicked(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Warning!", message: "Are you sure you want to delete this masterpiece?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No, changed my mind", style: .cancel) { (action) in}
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes Please", style: .default) { (action) in
            self.deleteSelectedDoodles()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {}
        
    }
    
    @objc func showImageButtonClicked(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showDoodle", sender: self)
        collectionView.deselectItem(at: indexPathOfSelectedCell!, animated: false)
        selectedCache.removeAll()
    }
    
    
    
    // MARK: - Photos methods
    
    
    func deleteAllPhotos() {
        
        
        for doodle in fetchedResultsController.fetchedObjects! {
            managedContext.delete(doodle)
        }
        
        self.saveContext(context: managedContext)
        
    }
    
    func deleteSelectedDoodles() {
        
        var doodlesToDelete = [Doodle]()
        
        for indexPath in selectedCache {
            doodlesToDelete.append(fetchedResultsController.object(at: indexPath))
            
        }
        
        for doodle in doodlesToDelete {
            managedContext.delete(doodle)
        }
        selectedCache.removeAll()
        
        self.saveContext(context: managedContext)
        
        enableLableCheck()
    }
    
    func saveContext (context: NSManagedObjectContext){
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save context \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    // MARK: - Fetch Request method
    
    func doFetch() {
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDoodle" {
            
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let doodles = fetchedResultsController.fetchedObjects
                doodle = doodles?[selectedIndexPath.row]
                let destinationVC = segue.destination as! DoodleInfoViewController
                destinationVC.doodle = doodle
                
            }
        }
    }
    
    
    
    
}

// MARK: - EXTENSION - CollectionView Delegate

extension SavedImagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        deleteButton?.isEnabled = true
        showImageButton?.isEnabled = true
        indexPathOfSelectedCell = indexPath
        
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        cell.alpha = 0.5
        cell.layer.borderColor = UIColor.MyTheme.redColor.cgColor
        
        
        if let index = selectedCache.index(of: indexPath) {
            selectedIndex = indexPath.row
            
            selectedCache.remove(at: index)
        } else {
            selectedCache.append(indexPath)
        }
        
        configure(cell, for: indexPath)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        deleteButton?.isEnabled = false
        showImageButton?.isEnabled = false
        
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        cell.alpha = 1.0
         cell.layer.borderColor = UIColor.black.cgColor
        if let index = selectedCache.index(of: indexPath) {
            selectedCache.remove(at: index)
        } else {
            selectedCache.append(indexPath)
        }
    }
    
}

// MARK: - EXTENSION - Internals

extension SavedImagesViewController {
    
    func configure(_ cell: UICollectionViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? ImageCollectionViewCell else { return }
        
        let doodle = fetchedResultsController.object(at: indexPath)
        
        let image = UIImage(data: doodle.image! as Data)!
        
        
        cell.update(with: image)
        
    }
    
    
    
}

// MARK: - EXTENSION - CollectionView Datasource

extension SavedImagesViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        guard let sections = fetchedResultsController.sections else { return 1 }
        
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        configure(cell, for: indexPath)
        
        return cell
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension SavedImagesViewController: NSFetchedResultsControllerDelegate {
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        insertedCache = [IndexPath]()
        deletedCache = [IndexPath]()
        updatedCache = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            
            insertedCache.append(newIndexPath!)
        case .delete:
            
            deletedCache.append(indexPath!)
        case .move:
            print("=== didChange .move type")
            deletedCache.append(indexPath!)
            insertedCache.append(newIndexPath!)
        case .update:
            updatedCache.append(indexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView.performBatchUpdates({
            for indexPath in self.insertedCache {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deletedCache {
                self.collectionView.deleteItems(at: [indexPath])
            }
            for indexPath in self.updatedCache {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
}

extension UIColor {
    struct MyTheme {
        static var redColor: UIColor  { return UIColor(red: 204/255, green: 24/255, blue: 30/255, alpha: 1) }

    }
}



