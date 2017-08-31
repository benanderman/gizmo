//
//  MainViewController.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var logoView: AnimatingSpringLogoView!
  
  var employees: [Employee]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    logoView.startAnimation()
    Employee.loadFromWeb { (employees: [Employee]?) in
      self.employees = employees
      self.logoView.stopAnimation()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
