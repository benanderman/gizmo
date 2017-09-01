//
//  ScoreViewController.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
  var score = 0
  var bestScore = 0
  var guessed = 0
  var guessedRight = 0
  
  @IBOutlet var diagonalView: UIView!
  @IBOutlet var playAgainButton: UIButton!
  @IBOutlet var backToHomeButton: UIButton!
  @IBOutlet var scoreLabel: UILabel!
  @IBOutlet var scoreContainer: UIView!
  @IBOutlet var bestScoreLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    styleButtons()
    
    diagonalView.layer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi * -2.5 / 180.0))
    scoreContainer.layer.cornerRadius = 10.0
  }
  
  func styleButtons() {
    playAgainButton.layer.cornerRadius = 3.0
    backToHomeButton.layer.cornerRadius = 3.0
    backToHomeButton.layer.borderColor = UIColor.white.cgColor
    playAgainButton.layer.borderColor = UIColor.white.cgColor
    backToHomeButton.layer.borderWidth = 2.5
    playAgainButton.layer.borderWidth = 2.5
  }
  
  override func viewWillAppear(_ animated: Bool) {
    scoreLabel.text = "\(score)"
    bestScoreLabel.text = "Your Best Score: \(score)"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func playAgainTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
