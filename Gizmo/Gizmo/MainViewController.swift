//
//  MainViewController.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var logoText: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
  @IBOutlet weak var leaderboardButton: UIButton!
  
  var employees: [Employee]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    styleButton(button: settingsButton)
    styleButton(button: leaderboardButton)
    
    startButton.layer.cornerRadius = 3.0
    
    settingsButton.isEnabled = false
    
    // Do any additional setup after loading the view.
    Employee.loadFromWeb { [weak self] (employees: [Employee]?) in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.employees = employees
      
      DispatchQueue.main.async {
        strongSelf.settingsButton.isEnabled = true
      }
    }
  }
  
  func styleButton(button: UIButton) {
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.cornerRadius = 3.0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    let slowDuration = 0.5
    let duration: CFTimeInterval = 0.15
    
    let buttons: [UIView?] = [self.startButton, self.settingsButton, self.leaderboardButton]
    let logoViews: [UIView?] = [self.logoImage, self.logoText]
    
    UIView.animate(withDuration: 1.5) {
      
      let fade = CABasicAnimation(keyPath: "opacity")
      fade.fromValue = 0.0
      fade.toValue = 1.0
      fade.duration = duration
      fade.fillMode = kCAFillModeBackwards
      fade.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
      
      let translateY = CABasicAnimation(keyPath: "transform.translation.y")
      translateY.fromValue = self.view.frame.size.height / 2 - self.logoImage.superview!.frame.origin.y - self.logoImage.frame.size.height / 2
      translateY.toValue = 0.0
      translateY.duration = slowDuration
      translateY.fillMode = kCAFillModeBackwards
      translateY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
      var beginTime = CACurrentMediaTime()
      for view in logoViews {
        translateY.beginTime = beginTime
        fade.beginTime = beginTime
        if let layer = view?.layer {
          if view != self.logoImage {
            layer.add(fade, forKey: nil)
          }
          layer.add(translateY, forKey: nil)
          beginTime += 0.8 * slowDuration
        }
      }
      
      for view in buttons {
        fade.beginTime = beginTime
        if let layer = view?.layer {
          layer.add(fade, forKey: "fade")
          beginTime += 0.8 * duration
        }
      }
    }
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.destination is GameViewController {
      guard let employees = employees else {
        return
      }
      
      var count = 0
      for employee in employees {
        if employee.🖼 != nil {
          count += 1
        }
      }
      
      print("image count = \(count)")
      
      guard count >= 40 else {
        let alert = UIAlertController(title: "WHOA NELLIE!", message: "Can you give us a minute? We're trying to load some stuff.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        return
      }
      
      let vc = segue.destination as! GameViewController
      vc.employees = employees
    }
    else if segue.destination is EmployeeDirectoryViewController {
      let vc = segue.destination as! EmployeeDirectoryViewController
      vc.employees = employees
    }
  }
  
  
  @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    
  }
  
}
