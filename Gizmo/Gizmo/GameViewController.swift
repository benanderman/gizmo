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
  
  @IBOutlet weak var buttonStackView: UIStackView!
  @IBOutlet weak var labelStackView: UIStackView!
  @IBOutlet weak var winLossLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var tapView: UIView!
  
  var employees: [Employee]!
  
  private var firstNames = Set<String>()
  private var currentEmployee: Employee?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = imageView.frame.width / 2
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
    tapView.addGestureRecognizer(gestureRecognizer)
    
    showButtons(true)
    
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
    
    showButtons(false)
    
    guard let employee = currentEmployee else {
      return
    }
    
    let nameAndTitle = "\(employee.firstName), \(employee.title)"
    let description: String
    
    if button.titleLabel?.text == employee.firstName {
      winLossLabel.text = "YES FRIEND!"
      description = "I'm \(nameAndTitle). You are great."
    }
    else {
      winLossLabel.text = "NOPE!!"
      description = "I'm \(nameAndTitle). Pls remember my name. :("
    }
    
    guard let range = description.range(of: nameAndTitle) else {
      return
    }
    
    let mutableDescription = NSMutableAttributedString(string: description, attributes: [
      NSFontAttributeName: UIFont(name: "FunctionPro-Medium", size: 22)!
      ])
    mutableDescription.addAttribute(NSFontAttributeName, value: UIFont(name: "FunctionPro-Demi", size: 22)!, range: description.nsRange(from: range))
    
    descriptionLabel.attributedText = mutableDescription
  }
  
  func showButtons(_ visible: Bool) {
    buttonStackView.isHidden = !visible
    labelStackView.isHidden = visible
    tapView.isHidden = visible
  }
  
  func screenTapped() {
    showButtons(true)
    showEmployee()
  }
}

extension String {
  func nsRange(from range: Range<Index>) -> NSRange {
    let lower = UTF16View.Index(range.lowerBound, within: utf16)
    let upper = UTF16View.Index(range.upperBound, within: utf16)
    return NSRange(location: utf16.startIndex.distance(to: lower), length: lower.distance(to: upper))
  }
}
