//
//  ViewController.swift
//  BondVillains
//
//  Created by Jason on 11/19/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
  
//TODO: think of replacing all necessary indexPaths with selectedRows for clarity.
  
    // Get ahold of some villains, for the table
    // This is an array of Villain instances
    var allVillains = Villain.allVillains
    let genericVillain = [Villain.NameKey : "Generic Villain", Villain.EvilSchemeKey : "Generic Evil Scheme.",  Villain.ImageNameKey : "Generic"]
  
  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var deleteButton: UIBarButtonItem!
  @IBOutlet var editButton: UIBarButtonItem!
  @IBOutlet var cancelButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // make our view consistent
    self.updateButtonsToMatchTableState()
  }
  
    //MARK: Table View Actions
  
  @IBAction func addAction(sender: AnyObject) {
    // Tell the tableView we're going to add (or remove) items.
    self.tableView.beginUpdates()
    // Add an item to the array.
    allVillains.append(Villain(dictionary: genericVillain))
    
    // Tell the tableView about the item that was added.
    let indexPathForNewItem = NSIndexPath(forItem: allVillains.count - 1, inSection: 0)
    tableView.insertRowsAtIndexPaths([indexPathForNewItem], withRowAnimation: .Automatic)
    
    // Tell the tableView we have finished adding or removing items.
    self.tableView.endUpdates()
    
    // Scroll the tableView so the new item is visible
    self.tableView.scrollToRowAtIndexPath(indexPathForNewItem, atScrollPosition: .Bottom, animated: true)
    
    // Update the buttons if we need to.
    self.updateButtonsToMatchTableState()
  }
  
  @IBAction func deleteAction(sender: AnyObject) {
    
    let cancelTitle = "Cancel"
    let okTitle = "OK"
    var alertTitle = "Remove villains"
    var actionTitle = "Are you sure you want to remove these items?"
    
    if let indexPaths = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
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
    
    self.presentViewController(alertController, animated: true, completion: nil)
  }

  @IBAction func editAction(sender: AnyObject) {
    self.tableView.setEditing(true, animated: true)
    self.updateButtonsToMatchTableState()
  }
  
  @IBAction func cancelAction(sender: AnyObject) {
    self.tableView.setEditing(false, animated: true)
    self.updateButtonsToMatchTableState()
  }

  
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allVillains.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("VillainCell") as! UITableViewCell
        let villain = self.allVillains[indexPath.row]
        
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
      if self.tableView.editing{
        
        // Update the delete button's title based on how many items are selected.
        self.updateButtonsToMatchTableState()
      }else{
      let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController")! as! VillainDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
      }
    }
  
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
      
        // Update the delete button's title based on how many items are selected.
        self.updateDeleteButtonTitle()
    }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete{
      allVillains.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }
  
  //MARK: Methods for Add, Edit, Delete and Cancel actions
  
  func deleteSelection() {
    
    // Unwrap indexPaths to check if rows are selected
    if let _ = tableView.indexPathsForSelectedRows() {
      
      // Do while all selected rows are deleted
      do {
        
      if let indexPath = tableView.indexPathForSelectedRow(){
        
        //remove from table view data source and table view
        self.allVillains.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
      
      } while tableView.indexPathsForSelectedRows() != nil
    
    }else{
      
      // Delete everything, delete the objects from data model.
      self.allVillains.removeAll(keepCapacity: false)
      
      // Tell the tableView that we deleted the objects.
      // Because we are deleting all the rows, just reload the current table section
      self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    // Exit editing mode after the deletion.
    self.tableView.setEditing(false, animated: true)
    self.updateButtonsToMatchTableState()
  }
  

  
  func updateButtonsToMatchTableState(){
    if self.tableView.editing{
      
      // Show the option to cancel the edit.
      self.navigationItem.rightBarButtonItem = self.cancelButton

      self.updateDeleteButtonTitle()
      
      // Show the delete button.
      self.navigationItem.leftBarButtonItem = self.deleteButton
    }else{
      
      // Not in editing mode.
      self.navigationItem.leftBarButtonItem = self.addButton
      
      // Show the edit button, but disable the edit button if there's nothing to edit.
      self.editButton.enabled = self.allVillains.isEmpty ? false : true
      self.navigationItem.rightBarButtonItem = self.editButton
    }
  }
  
  func updateDeleteButtonTitle(){
    
    // Update the delete button's title, based on how many items are selected
    if let indexPaths = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
      self.deleteButton.title = "Delete (\(indexPaths.count))"
      
      let allItemsAreSelected = indexPaths.count == self.allVillains.count ? true : false
      if allItemsAreSelected {self.deleteButton.title = "Delete All"}
    }else{
      self.deleteButton.title = "Delete All"
    }
  }
  
}

