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
  
  @IBOutlet weak var diagonalView: UIView!
  @IBOutlet weak var playAgainButton: UIButton!
  @IBOutlet weak var backToHomeButton: UIButton!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var scoreContainer: UIView!
  @IBOutlet weak var bestScoreLabel: UILabel!
  @IBOutlet weak var petView: UIImageView!
  @IBOutlet weak var petLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    styleButtons()
    
    diagonalView.layer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi * -2.5 / 180.0))
    diagonalView.layer.allowsEdgeAntialiasing = true;
    diagonalView.isHidden = true
    
    scoreContainer.layer.cornerRadius = 10.0
    
    determinePet()
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
    super.viewWillAppear(animated)
    scoreLabel.text = "\(score)"
    let bestScore = !HighScoreManager.localHighScores.isEmpty ? HighScoreManager.localHighScores[0].score : score
    bestScoreLabel.text = "Your Best Score: \(bestScore)"
    diagonalView.isHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    diagonalView.isHidden = true
  }
  
  @IBAction func playAgainTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  private func determinePet() {
    let percent = guessed == 0 ? 0.0 : Double(guessedRight) / Double(guessed)

    if percent < 0.3 {
      petView.image = #imageLiteral(resourceName: "cat")
      petLabel.text = "Dang, do you even work here???"
    }
    else if percent > 0.7 {
      petView.image = #imageLiteral(resourceName: "doge")
      petLabel.text = "Wow much points. Such amaze."
    }
    else {
      petView.image = #imageLiteral(resourceName: "pug")
      petLabel.text = "Um... what's YOUR name?"
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

}
