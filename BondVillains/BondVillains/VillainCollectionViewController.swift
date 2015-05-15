//
//  VillainCollectionViewController.swift
//  BondVillains
//
//  Created by Gabrielle Miller-Messner on 2/3/15.
//  Modified by Sergei on 04/05/15.
//  Copyright (c) 2015 Udacity. All rights reserved.


import Foundation

import UIKit

class VillainCollectionViewController: UICollectionViewController, UICollectionViewDataSource {

  let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  
  // Create generic villain property to use as example for addAction
  let genericVillain = [Villain.NameKey : "Generic Villain", Villain.EvilSchemeKey : "Generic Evil Scheme.",  Villain.ImageNameKey : "Generic"]
  // Declare empty array of type Villain for copy of selected objects when deleting
  var objectsToDelete = [Villain]()

  // Set the selecting property to check if we are in editing mode
  var selecting: Bool = false {
    didSet {
      collectionView?.allowsMultipleSelection = selecting
      // Clear previous selection if any
      collectionView?.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
    }
  }
  
  // MARK: @IBOutlets
  
  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var deleteButton: UIBarButtonItem!
  @IBOutlet var editButton: UIBarButtonItem!
  @IBOutlet var cancelButton: UIBarButtonItem!
  
  
  //MARK: View
  
  override func viewDidLoad() {
    super.viewDidLoad()
     collectionView?.reloadData()
     updateButtonsToMatchTableState()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    collectionView?.reloadData()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    if selecting {
       self.selecting = !selecting
    }
    // make our view consistent
     updateButtonsToMatchTableState()
  }
  
  // MARK: @IBActions: Add, Delete, Edit, Cancel
  
  @IBAction func addAction(sender: AnyObject) {
    // Demo of adding items to the collectionView
    applicationDelegate.allVillains.append(Villain(dictionary: genericVillain))
    
    let indexPathForNewItem = NSIndexPath(forItem: applicationDelegate.allVillains.count - 1, inSection: 0)
    collectionView?.insertItemsAtIndexPaths([indexPathForNewItem])
    
    collectionView?.scrollToItemAtIndexPath(indexPathForNewItem, atScrollPosition: .Bottom, animated: true)
    
    // Update the buttons if we need to.
     updateButtonsToMatchTableState()
  }
  
  @IBAction func deleteAction(sender: AnyObject) {
    
    // Preparing UIAlertController to present the alert on deletion
    let cancelTitle = "Cancel"
    let okTitle = "OK"
    var alertTitle = "Remove villains"
    var actionTitle = "Are you sure you want to remove these items?"
    
    if let indexPaths = collectionView?.indexPathsForSelectedItems() {
      if indexPaths.count == 1 {
        alertTitle = "Remove villain"
        actionTitle = "Are you sure you want to remove this item?"
      }
    }
    
    
    let alertController = UIAlertController(title: alertTitle, message: actionTitle, preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Default) {action in  self.dismissViewControllerAnimated(true, completion: nil)}
    alertController.addAction(cancelAction)
    
    let okAction = UIAlertAction(title: okTitle, style: UIAlertActionStyle.Default) {action in  self.deleteSelection()}
    alertController.addAction(okAction)
    
     presentViewController(alertController, animated: true, completion: nil)
  }
  
  @IBAction func editAction(sender: AnyObject) {
    
    // Switch selecting state
     self.selecting = !selecting
     updateButtonsToMatchTableState()
  }
  
  @IBAction func cancelAction(sender: AnyObject) {
    self.selecting = !selecting
    collectionView?.reloadSections(NSIndexSet(index: 0))
    updateButtonsToMatchTableState()
  }
  
  // MARK: Table View Delegate methods
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return  applicationDelegate.allVillains.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VillainCollectionViewCell", forIndexPath: indexPath) as! VillainCollectionViewCell
    let villain =  applicationDelegate.allVillains[indexPath.row]
    
    // Set the name and image
    cell.nameLabel.text = villain.name
    cell.villainImageView?.image = UIImage(named: villain.imageName)
    cell.schemeLabel.text = "Scheme: \(villain.evilScheme)"
    
    // As cells are reused when slide in and out of the view, property of selected cell may apply to cell sliding into the view and apperas as selected though it actualy don't. I assume didHighlite didUnhighlite is a proper way to handle that. But for this example solution below is suffcient.
    // Check if cell is actually selected and set cell alpha value accordingly
    if cell.selected {
      cell.alpha = 0.5
    }else{
      cell.alpha = 1.0
    }
    
    return cell
  }
  
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
    if selecting {
      let cell = collectionView.cellForItemAtIndexPath(indexPath)
      //Change cell alpha value
      cell?.alpha = 0.5
      updateButtonsToMatchTableState()
    
    }else{
      
    let detailController = storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController")! as! VillainDetailViewController
    detailController.villain =  applicationDelegate.allVillains[indexPath.row]
    navigationController!.pushViewController(detailController, animated: true)
    }
  }

  override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    if selecting {
      let cell = collectionView.cellForItemAtIndexPath(indexPath)
      cell?.alpha = 1.0
      updateDeleteButtonTitle()
    }

  }
  
  //MARK: Methods to delelte selected items and configure buttons state
  
  func deleteSelection() {
    // Get selected items paths from collection View
    // Unwrapping here is not really necessary as .indexPathsForSelectedItems() returns empty array if no rows are selected and not nil.
    if let selectedRows = collectionView?.indexPathsForSelectedItems() as? [NSIndexPath]{
      // Check if rows are selected
      if !selectedRows.isEmpty {
        // Create temporary array of selected items
        for selectedRow in selectedRows{
          objectsToDelete.append(applicationDelegate.allVillains[selectedRow.row])
        }
        // Find objects from temporary array in data source and delete them
        for object in objectsToDelete {
          if let index = find(applicationDelegate.allVillains, object){
            applicationDelegate.allVillains.removeAtIndex(index)
            
            // Another method is to use .filter to remove objects from array
            //
            // func removeVillain(object: Villain) {
            //   applicationDelegate.allVillains = applicationDelegate.allVillains.filter( {$0 != object} )
            // }
            //
            // And another is to extend Array functionality. Not covered here.
          }
        }
        collectionView?.deleteItemsAtIndexPaths(selectedRows)
       // Clear temporary array just in case
       objectsToDelete.removeAll(keepCapacity: false)
      
      }else{
        
        // Delete everything, delete the objects from data model.
        applicationDelegate.allVillains.removeAll(keepCapacity: false)
        collectionView?.reloadSections(NSIndexSet(index: 0))
      }
       self.selecting = !selecting
       updateButtonsToMatchTableState()
    }
  }
  
  func updateButtonsToMatchTableState(){
    if selecting {
      
      // Show the option to cancel the edit.
       navigationItem.rightBarButtonItem = cancelButton
      
       updateDeleteButtonTitle()
      
      // Show the delete button.
      navigationItem.leftBarButtonItem = deleteButton
    }else{
      
      // Not in editing mode.
      navigationItem.leftBarButtonItem = addButton
      
      // Show the edit button, but disable the edit button if there's nothing to edit.
      editButton.enabled = applicationDelegate.allVillains.isEmpty ? false : true
      navigationItem.rightBarButtonItem = editButton
    }
  }
  
  func updateDeleteButtonTitle(){
    
    // Update the delete button's title, based on how many items are selected
    if let selectedRows = collectionView?.indexPathsForSelectedItems() as? [NSIndexPath]{
      
      let allItemsAreSelected = selectedRows.count == applicationDelegate.allVillains.count ? true : false
      let noItemsAreSelected = selectedRows.isEmpty
      
      if allItemsAreSelected || noItemsAreSelected {
        deleteButton.title = "Delete All"
      }else{
        deleteButton.title = "Delete (\(selectedRows.count))"
      }
    }
  }

  //end of class
}