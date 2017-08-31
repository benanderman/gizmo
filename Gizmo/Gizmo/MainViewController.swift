//
//  MainViewController.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
  @IBOutlet weak var leaderboardButton: UIButton!
  
  var employees: [Employee]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    styleButton(button: settingsButton)
    styleButton(button: leaderboardButton)
    
    // Do any additional setup after loading the view.
    Employee.loadFromWeb { [weak self] (employees: [Employee]?) in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.employees = employees
    }
  }
  
  func styleButton(button: UIButton) {
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.white.cgColor
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    
  }
  
}
