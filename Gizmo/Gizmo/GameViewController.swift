//
//  GameViewController.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, EmojiAnimator {
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var homeButton: UIButton!
  
  @IBOutlet var buttons: [UIButton]!
  
  @IBOutlet weak var buttonStackView: UIStackView!
  @IBOutlet weak var labelStackView: UIStackView!
  @IBOutlet weak var winLossLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  @IBOutlet weak var tapView: UIView!
  
  var employees: [Employee]!
  private var gameEmployees: [Employee]!
  
  private var firstNames = Set<String>()
  private var currentEmployee: Employee?
  
  private var guessed = 0
  private var guessedRight = 0
  private var score = 0
  private var secondsLeft = 0
  private var streak = 0
  
  private var timer = Timer()
  
  private var animationView = SKView()
  
  private let confettiEmoji: [Character] = ["😃", "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐔", "👌", "🎈", "🎉"]
  private let sadEmoji: [Character] = ["😔", "😟", "😕", "🙁", "😧", "😢", "😓", "😩"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    animationView.allowsTransparency = true
    view.addSubview(animationView)
    // Move the buttons and the tapView to the top.
    view.addSubview(buttonStackView)
    view.addSubview(tapView)
    view.addSubview(homeButton)
    
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = imageView.frame.width / 2
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
    tapView.addGestureRecognizer(gestureRecognizer)
    
    for button in buttons {
      button.layer.cornerRadius = 3.0
    }
    
    // Do any additional setup after loading the view.
    guard let employees = employees else {
      return
    }
    
    for employee in employees {
      firstNames.insert(employee.firstName)
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    
    // Shuffle the list
    self.gameEmployees = employees.shuffled()
    
    showButtons(true)
    
    showEmployee()
    
    guessed = 0
    guessedRight = 0
    score = 0
    scoreLabel.text = "\(score)"
    secondsLeft = 60
    timerLabel.text = "1:00"
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
      self?.updateTimer()
    })
    
    if animationView.scene == nil {
      let scene = makeScene()
      animationView.frame.size = scene.size
      animationView.presentScene(scene)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    animationView.center.x = view.bounds.midX
    animationView.center.y = view.bounds.midY
  }
  
  func updateTimer() {
    secondsLeft -= 1
    let minutes = secondsLeft / 60
    let seconds = secondsLeft % 60
    let zero = seconds < 10 ? "0" : ""
    timerLabel.text = "\(minutes):\(zero)\(seconds)"
    
    if secondsLeft == 0 {
      timeRanOut()
    }
  }
  
  func timeRanOut() {
    timer.invalidate()
    if HighScoreManager.name == nil {
      let alertController = UIAlertController(title: "High score!", message: nil, preferredStyle: .alert)
      
      let confirmAction = UIAlertAction(title: "Submit", style: .default) { [weak self] (_) in
        HighScoreManager.name = alertController.textFields?[0].text ?? "Mystery Person"
        HighScoreManager.addHighScore(score: self?.score ?? 0)
        self?.performSegue(withIdentifier: "toScoreView", sender: self)
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (_) in
        HighScoreManager.addHighScore(score: self?.score ?? 0)
        self?.performSegue(withIdentifier: "toScoreView", sender: self)
      }
      
      alertController.addTextField { (textField) in
        textField.placeholder = "Name"
      }
      
      alertController.addAction(confirmAction)
      alertController.addAction(cancelAction)
      
      self.present(alertController, animated: true, completion: nil)
    } else {
      HighScoreManager.addHighScore(score: self.score)
      self.performSegue(withIdentifier: "toScoreView", sender: self)
    }
  }
  
  func showEmployee() {
    guard gameEmployees != nil else {
      return
    }
    
    // Find the first employee with an image
    guard let (employee, index) = getNextEmployee() else {
      timeRanOut()
      return
    }
    
    currentEmployee = employee
    imageView.image = employee.🖼
    
    let validFirstNames = buildValidFirstNames(employee: employee)
    
    for (index, button) in buttons.enumerated() {
      button.setTitle(validFirstNames[index], for: .normal)
    }
    
    self.gameEmployees.remove(at: index)
  }
  
  private func getNextEmployee() -> (Employee, Int)? {
    guard let employees = gameEmployees else {
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
    
    let nameAndTitle = "\(employee.fullName), \(employee.title)"
    let description: String
    
    guessed += 1
    if button.titleLabel?.text == employee.firstName {
      winLossLabel.text = "Yes!"
      description = "I'm \(nameAndTitle). You are great."
      guessedRight += 1
      streak += 1
      score += 10 * streak
      scoreLabel.text = "\(score)"
      
      addClapEmoji()
      addConfettiEmoji(streak)
    }
    else {
      winLossLabel.text = "Excuse me?"
      description = "I'm \(nameAndTitle). Please remember my name."
      
      let numEmoji = streak == 0 ? 1 : streak
      addSadEmoji(numEmoji)
      
      streak = 0
    }
    
    guard let range = description.range(of: nameAndTitle) else {
      return
    }
    
    let mutableDescription = NSMutableAttributedString(string: description, attributes: [
      NSFontAttributeName: UIFont(name: "FunctionPro-Book", size: 22)!
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
  
  @IBAction func homeButtonTapped(_ sender: Any) {
    timer.invalidate()
    navigationController?.popViewController(animated: true)
  }
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if let vc = segue.destination as? ScoreViewController {
      vc.score = score
      vc.guessed = guessed
      vc.guessedRight = guessedRight
    }
  }
  
  private func addClapEmoji() {
    let emoji = addEmoji("👏", to: animationView.scene!)
    emoji.position.y -= 90
    
    let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.3)
    let scaleDownAction = SKAction.scale(to: 1, duration: 0.3)
    
    let removeNodeAction = SKAction.removeFromParent()
    
    let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction, scaleUpAction, scaleDownAction, removeNodeAction])
    
    emoji.run(scaleActionSequence)
  }
  
  private func addConfettiEmoji(_ numberOfEmoji: Int) {
    guard let scene = animationView.scene else {
      return
    }
    
    let idx = Int(arc4random_uniform(UInt32(confettiEmoji.count)))
    let char = confettiEmoji[idx]
    
    var duration = 0.1
    for lcv in 1...numberOfEmoji {
      let emoji = addEmoji(char, to: scene)
      
      let targetX = CGFloat(arc4random_uniform(UInt32(scene.frame.width)))
      let targetY = scene.frame.height
      
      let targetPoint = CGPoint(x: targetX, y: targetY)
      let moveAction = SKAction.move(to: targetPoint, duration: 1)
      moveAction.timingMode = .easeOut
      
      let offset = Double(lcv - 1)
      let waitAction  = SKAction.wait(forDuration:duration * offset)
      duration -= 0.01
      duration = max(duration, 0)
      
      let fadeAction = SKAction.fadeOut(withDuration: 1)
      
      let groupAction = SKAction.group([moveAction, fadeAction])
      
      let removeNodeAction = SKAction.removeFromParent()
      
      let actionSequence = SKAction.sequence([waitAction, groupAction, removeNodeAction]);
      
      emoji.run(actionSequence)
    }
  }
  
  private func addSadEmoji(_ numberOfEmoji: Int) {
    guard let scene = animationView.scene else {
      return
    }
    
    let idx = Int(arc4random_uniform(UInt32(sadEmoji.count)))
    let char = sadEmoji[idx]
    
    var duration = 0.1
    for lcv in 1...numberOfEmoji {
      let emoji = addEmoji(char, to: animationView.scene!)
      
      let targetX = numberOfEmoji == 1 ? emoji.position.x : CGFloat(arc4random_uniform(UInt32(scene.frame.width)))
      let targetY: CGFloat = 0
      
      let targetPoint = CGPoint(x: targetX, y: targetY)
      let moveAction = SKAction.move(to: targetPoint, duration: 1)
      moveAction.timingMode = .easeOut
      
      let offset = Double(lcv - 1)
      let waitAction  = SKAction.wait(forDuration:duration * offset)
      duration -= 0.01
      duration = max(duration, 0)
      
      let fadeAction = SKAction.fadeOut(withDuration: 1)
      
      let groupAction = SKAction.group([moveAction, fadeAction])
      
      let removeNodeAction = SKAction.removeFromParent()
      
      let actionSequence = SKAction.sequence([waitAction, groupAction, removeNodeAction]);
      
      emoji.run(actionSequence)
    }
  }
}

extension String {
  func nsRange(from range: Range<Index>) -> NSRange {
    let lower = UTF16View.Index(range.lowerBound, within: utf16)
    let upper = UTF16View.Index(range.upperBound, within: utf16)
    return NSRange(location: utf16.startIndex.distance(to: lower), length: lower.distance(to: upper))
  }
}
