//
//  HighScoreManager.swift
//  Gizmo
//
//  Created by Ben Anderman on 9/1/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import Foundation
import UIKit

struct HighScore {
  let userId: String
  let name: String
  let score: Int
  let timestamp: Int

  init(userId: String, name: String, score: Int, timestamp: Int) {
    self.userId = userId
    self.name = name
    self.score = score
    self.timestamp = timestamp
  }
  
  init(dictionary: [String:Any]) {
    self.userId = dictionary["user_id"] as? String ?? ""
    self.name = dictionary["name"] as? String ?? ""
    self.score = dictionary["score"] as? Int ?? 0
    self.timestamp = dictionary["timestamp"] as? Int ?? 0
  }
  
  var dictionary: [String:Any] {
    return [
      "user_id": userId,
      "name": name,
      "score": score,
      "timestamp": timestamp
    ]
  }
}

class HighScoreManager {
  static var localHighScores = [HighScore]()
  static var globalHighScores = [HighScore]()
  
  static var userId: String {
    return UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
  }
  
  static func isScoreHigh(score: Int) -> Bool {
    if localHighScores.count < maxLocalScores {
      return true
    }
    return localHighScores.last!.score < score
  }
  
  static func addHighScore(score: Int, name: String) {
    let newHighScore = HighScore(userId: self.userId,
                                 name: name,
                                 score: score,
                                 timestamp: Int(Date().timeIntervalSince1970))
    
    var insertIndex = 0
    for highScore in self.localHighScores {
      if highScore.score >= score {
        insertIndex += 1
      } else {
        break
      }
    }
    self.localHighScores.insert(newHighScore, at: insertIndex)
    while self.localHighScores.count > maxLocalScores {
      self.localHighScores.removeLast()
    }
    saveLocalHighScores()
    
    if (insertIndex == 0) {
      postGlobalHighScore(score: newHighScore, completion: {})
    }
  }
  
  static func saveLocalHighScores() {
    let url = self.highScoreFileURL
    let highScoreDictionaries = self.localHighScores.map { $0.dictionary }
    NSKeyedArchiver.archiveRootObject(highScoreDictionaries, toFile: url.path)
  }
  
  static func loadLocalHighScores() {
    let url = self.highScoreFileURL
    let highScoreDictionaries = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? [[String:Any]]
    guard highScoreDictionaries != nil else { return }
    self.localHighScores = highScoreDictionaries!.map { HighScore(dictionary: $0) }
  }
  
  static func postGlobalHighScore(score: HighScore, completion: () -> Void) {
    let url = URL(string: "https://gizmo-app-backend.herokuapp.com/scores/\(score.userId)")
    let session = URLSession.shared
    let request = NSMutableURLRequest(url: url! as URL)
    request.httpMethod = "POST"

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: score.dictionary, options: .prettyPrinted)
    } catch let error {
        print(error.localizedDescription)
    }
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
        guard error == nil else { return }
    })

    task.resume()
  }
  
  static func fetchGlobalHighScores(completion: @escaping ([HighScore]) -> Void) {
    let url = URL(string: "https://gizmo-app-backend.herokuapp.com/scores")
    let session = URLSession.shared
    let request = NSMutableURLRequest(url: url! as URL)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
        guard let data = data, error == nil else { return }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {
                var scores: [HighScore] = []
                for raw in json {
                    let rawScore = raw as! [String: Any]
                    scores.append(HighScore(dictionary: rawScore))
                }
                completion(scores)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    })

    task.resume()
  }
  
  // MARK: - Private
  static let maxLocalScores = 10
  
  static private var highScoreFileURL: URL {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0].appendingPathComponent("highscores")
  }
}
