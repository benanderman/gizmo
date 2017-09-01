//
//  HighScoresViewController.swift
//  Gizmo
//
//  Created by Ben Anderman on 9/1/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit

enum HighScoreMode {
  case Global
  case Local
}

class HighScoresViewController: UIViewController {
  
  var mode: HighScoreMode = .Local
  
  override func viewWillAppear(_ animated: Bool) {
    HighScoreManager.fetchGlobalHighScores {
      
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
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

}

extension HighScoresViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if mode == .Local {
      return HighScoreManager.localHighScores.count
    } else {
      return HighScoreManager.globalHighScores.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath)
    var highScore: HighScore
    if mode == .Local {
      highScore = HighScoreManager.localHighScores[indexPath.row]
    } else {
      highScore = HighScoreManager.globalHighScores[indexPath.row]
    }
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let score = numberFormatter.string(from: NSNumber(value: highScore.score))
    
    if mode == .Local {
      let date = Date(timeIntervalSince1970: TimeInterval(highScore.timestamp))
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US")
      dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd h:mm a")
      cell.textLabel?.text = dateFormatter.string(from: date)
    } else {
      cell.textLabel?.text = highScore.name
    }
    
    cell.detailTextLabel?.text = "\(score ?? "0") points"
    return cell
  }
}
