//
//  GameViewController.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet var buttons: [UIButton]!
  
  var employees: [Employee]!
  
  private var firstNames = Set<String>()
  private var currentEmployee: Employee?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    guard let employees = employees else {
      return
    }
    
    for employee in employees {
      firstNames.insert(employee.firstName)
    }
    
    // Shuffle the list
    self.employees = employees.shuffled()
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated);
    showEmployee()
  }
  
  func showEmployee() {
    guard employees != nil else {
      return
    }
    
    // Find the first employee with an image
    guard let (employee, index) = getNextEmployee() else {
      return
    }
    
    currentEmployee = employee
    imageView.image = employee.🖼
    
    let validFirstNames = buildValidFirstNames(employee: employee)
    
    for (index, button) in buttons.enumerated() {
      button.setTitle(validFirstNames[index], for: .normal)
    }
    
    self.employees.remove(at: index)
  }
  
  private func getNextEmployee() -> (Employee, Int)? {
    guard let employees = employees else {
      return nil
    }
    
    guard employees.count > 0 else {
      return nil
    }
    
    var lcv = 0
    var employee = employees[lcv]
    while (employee.🖼 == nil) {
      lcv += 1
      employee = employees[lcv]
    }
    
    return (employee, lcv)
  }
  
  private func buildValidFirstNames(employee: Employee) -> [String] {
    var nameSet = Set<String>()
    
    nameSet.insert(employee.firstName)
    
    let firstNameArray = Array(firstNames)
    
    while nameSet.count < 4 {
      let idx = Int(arc4random_uniform(UInt32(firstNameArray.count)))
      let randomName = firstNameArray[idx]
      nameSet.insert(randomName)
    }
    
    return Array(nameSet).shuffled()
  }
  
  @IBAction func nameTapped(_ sender: Any) {
    guard let button = sender as? UIButton else {
      return
    }
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.showEmployee()
    })
    
    if button.titleLabel?.text == currentEmployee?.firstName {
      let alert = UIAlertController(title: "WINNER!", message: "You're good.", preferredStyle: .alert)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    }
    else {
      let alert = UIAlertController(title: "WRONG!", message: "You're bad.", preferredStyle: .alert)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    }
  }
}
