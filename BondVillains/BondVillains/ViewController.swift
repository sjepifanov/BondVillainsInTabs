//
//  ViewController.swift
//  BondVillains
//
//  Created by Jason on 11/19/14.
//  Modified by Sergei on 04/05/15.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
  
  let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  
  // Create generic villain property to use as example for addAction
  let genericVillain = [Villain.NameKey : "Generic Villain", Villain.EvilSchemeKey : "Generic Evil Scheme.",  Villain.ImageNameKey : "Generic"]
 
  // MARK: @IBOutlets
  
  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var deleteButton: UIBarButtonItem!
  @IBOutlet var editButton: UIBarButtonItem!
  @IBOutlet var cancelButton: UIBarButtonItem!
  
  // MARK: View
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.allowsMultipleSelectionDuringEditing = true
    // make our view consistent
    tableView.reloadData()
    updateButtonsToMatchTableState()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    tableView.reloadData()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    tableView.setEditing(false, animated: true)
    // make our view consistent
    updateButtonsToMatchTableState()

  }
  
  // MARK: @IBActions: Add, Delete, Edit, Cancel
  
  @IBAction func addAction(sender: AnyObject) {
    // Tell the tableView we're going to add (or remove) items.
    tableView.beginUpdates()
    // Add an item to the array.
    applicationDelegate.allVillains.append(Villain(dictionary: genericVillain))
    
    // Tell the tableView about the item that was added.
    let indexPathForNewItem = NSIndexPath(forItem: applicationDelegate.allVillains.count - 1, inSection: 0)
    tableView.insertRowsAtIndexPaths([indexPathForNewItem], withRowAnimation: .Automatic)
    
    // Tell the tableView we have finished adding or removing items.
    tableView.endUpdates()
    
    // Scroll the tableView so the new item is visible
    tableView.scrollToRowAtIndexPath(indexPathForNewItem, atScrollPosition: .Bottom, animated: true)
    
    // Update the buttons if we need to.
    updateButtonsToMatchTableState()
  }
  
  @IBAction func deleteAction(sender: AnyObject) {
    
    let cancelTitle = "Cancel"
    let okTitle = "OK"
    var alertTitle = "Remove villains"
    var actionTitle = "Are you sure you want to remove these items?"
    
    if let indexPaths = tableView.indexPathsForSelectedRows() {
      if indexPaths.count == 1 {
      alertTitle = "Remove villain"
      actionTitle = "Are you sure you want to remove this item?"
      }
    }
    
    
    let alertController = UIAlertController(title: alertTitle, message: actionTitle, preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Default) {action in self.dismissViewControllerAnimated(true, completion: nil)}
    alertController.addAction(cancelAction)
    
    let okAction = UIAlertAction(title: okTitle, style: UIAlertActionStyle.Default) {action in self.deleteSelection()}
    alertController.addAction(okAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }

  @IBAction func editAction(sender: AnyObject) {
    tableView.setEditing(true, animated: true)
    updateButtonsToMatchTableState()
  }
  
  @IBAction func cancelAction(sender: AnyObject) {
    tableView.setEditing(false, animated: true)
    updateButtonsToMatchTableState()
  }

  
  // MARK: Table View Delegate methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicationDelegate.allVillains.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("VillainCell") as! UITableViewCell
        let villain = applicationDelegate.allVillains[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = villain.name
        cell.imageView?.image = UIImage(named: villain.imageName)
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "Scheme: \(villain.evilScheme)"
        }
        
        return cell
    }
  
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if tableView.editing{
        
        // Update the delete button's title based on how many items are selected.
        updateButtonsToMatchTableState()
      }else{
      let detailController = storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController")! as! VillainDetailViewController
        detailController.villain = applicationDelegate.allVillains[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
      }
    }
  
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
      
        // Update the delete button's title based on how many items are selected.
        updateDeleteButtonTitle()
    }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete{
      applicationDelegate.allVillains.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }
  
  //MARK: Methods to delelte selected items and configure buttons state
  
  func deleteSelection() {
    
    // Not the efficient way to remove objects. .filter, find() or extending Array functionality should be used instead.
    // Though I've kind of figured it out on my own hence left here as example. :)
    // Check collectionView for find() and .filter examples.
    
    // Unwrap indexPaths to check if rows are selected
    if let _ = tableView.indexPathsForSelectedRows() {
      
      // Delete rows from data source and tableView while all selected rows are deleted
      do {
        
      if let selectedRow = tableView.indexPathForSelectedRow(){
        
        //remove from table view data source and table view
        applicationDelegate.allVillains.removeAtIndex(selectedRow.row)
        tableView.deleteRowsAtIndexPaths([selectedRow], withRowAnimation: .Automatic)
        }
      
      } while tableView.indexPathsForSelectedRows() != nil
    
    }else{
      
      // Delete everything, delete the objects from data model.
      applicationDelegate.allVillains.removeAll(keepCapacity: false)
      
      // Tell the tableView that we deleted the objects.
      // Because we are deleting all the rows, just reload the current table section
      tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    // Exit editing mode after the deletion.
    tableView.setEditing(false, animated: true)
    updateButtonsToMatchTableState()
  }
  

  
  func updateButtonsToMatchTableState(){
    if tableView.editing{
      
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
    if let selectedRows = tableView.indexPathsForSelectedRows() {
      deleteButton.title = "Delete (\(selectedRows.count))"
      
      let allItemsAreSelected = selectedRows.count == applicationDelegate.allVillains.count ? true : false
      if allItemsAreSelected {self.deleteButton.title = "Delete All"}
    }else{
      deleteButton.title = "Delete All"
    }
  }
  
}

