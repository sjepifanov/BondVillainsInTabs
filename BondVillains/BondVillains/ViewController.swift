//
//  ViewController.swift
//  BondVillains
//
//  Created by Jason on 11/19/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Get ahold of some villains, for the table
    // This is an array of Villain instances
    var allVillains = Villain.allVillains
  
  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var deleteButton: UIBarButtonItem!
  @IBOutlet var editButton: UIBarButtonItem!
  @IBOutlet var cancelButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.updateButtonsToMatchTableState()
  }
  
    //MARK: Table View Actions
  
  @IBAction func addAction(sender: AnyObject) {
    //TODO: write implementation
  }
  
  @IBAction func deleteAction(sender: AnyObject) {
    
    
    var alertTitle = "Remove villains"
    var actionTitle = "Are you sure you want to remove these items?"
    let cancelTitle = "Cancel"
    let okTitle = "OK"
    
    if let selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
      if selectedRows.count == 1 {
      alertTitle = "Remove villain"
      actionTitle = "Are you sure you want to remove this item?"
      }
    }
    
    let nextController = UIAlertController(title: alertTitle, message: actionTitle, preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Default) {action in self.dismissViewControllerAnimated(true, completion: nil)}
    nextController.addAction(cancelAction)
    
    let okAction = UIAlertAction(title: okTitle, style: UIAlertActionStyle.Default) {action in self.deleteSelection()}
    nextController.addAction(okAction)
    
    self.presentViewController(nextController, animated: true, completion: nil)
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
      println("in didSelectRow")
      if self.tableView.editing{
        self.updateButtonsToMatchTableState()
      }else{
      let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController")! as! VillainDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
      }
    }
  
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.updateDeleteButtonTitle()
    }
  
  //MARK: Methods for Add, Edit, Delete and Cancel actions
  
  func deleteSelection (){
      // Delete what the user selected.
      // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
      if let indexPaths = tableView.indexPathsForSelectedRows() as? [NSIndexPath]{
        
        for indexPath in indexPaths{
          //remove from table view data source
          self.allVillains.removeAtIndex(indexPath.row)
        }
          //remove rows from table view
        tableView.deleteRowsAtIndexPaths([indexPaths], withRowAnimation: .Automatic)
        
      }else{
        // Delete everything, delete the objects from our data model.
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
      self.navigationItem.rightBarButtonItem = self.cancelButton
      self.updateDeleteButtonTitle()
      self.navigationItem.leftBarButtonItem = self.deleteButton
    }else{
      self.navigationItem.leftBarButtonItem = self.addButton
      
      if self.allVillains.isEmpty {
        self.editButton.enabled = false
      }else{
        self.editButton.enabled = true
      }
      
      self.navigationItem.rightBarButtonItem = self.editButton
    }
  }
  
  
  func updateDeleteButtonTitle(){
    if let selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath]{
      let allItemsAreSelected = selectedRows.count == self.allVillains.count ? true : false
      self.deleteButton.title = "Delete (\(selectedRows.count))"
      if allItemsAreSelected {self.deleteButton.title = "Delete All"}
    }else{
      self.deleteButton.title = "Delete All"
    }
  }
  
//end of class
}

