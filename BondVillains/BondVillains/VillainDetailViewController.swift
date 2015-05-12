//
//  VillainDetailViewController.swift
//  BondVillains
//
//  Created by Sergei on 30/04/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class VillainDetailViewController: UIViewController {
  
  @IBOutlet weak var villainImage: UIImageView!
  @IBOutlet weak var villainName: UILabel!
  
  var villain: Villain!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.villainImage.image = UIImage(named: villain.imageName)
    self.villainName.text = villain.name
    
  }
  
  
  //TODO: write an implementation
}
