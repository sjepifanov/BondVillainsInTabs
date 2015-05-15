//
//  VillainDetailViewController.swift
//  BondVillains
//
//  Created by Jason on 12/12/14.
//  Modified by Sergei on 30/04/15.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class VillainDetailViewController: UIViewController {
  
  @IBOutlet weak var villainImage: UIImageView!
  @IBOutlet weak var villainName: UILabel!
  @IBOutlet weak var villainScheme: UILabel!
  
  var villain: Villain!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.villainImage.image = UIImage(named: villain.imageName)
    self.villainName.text = villain.name
    self.villainScheme.text = villain.evilScheme
    
  }
  
}
