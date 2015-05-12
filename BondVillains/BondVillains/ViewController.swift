//
//  ViewController.swift
//  BondVillains
//
//  Created by Jason on 11/19/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Get ahold of some villains, for the table
    // This is an array of Villain instances
    let allVillains = Villain.allVillains
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allVillains.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("in numberofrows")
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
  
/*    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
    return true
    }*/

  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      println("in didSelectRow")
      let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController")! as! VillainDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
  }

  
}

