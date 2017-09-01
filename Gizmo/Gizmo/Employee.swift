//
//  Employee.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import Foundation
import UIKit

class Employee {
  let firstName: String
  let lastName: String
  let department: String
  let title: String
  let url: URL
  var 🖼: UIImage?
  
  init(firstName: String, lastName: String, department: String, title: String, url: URL) {
    self.firstName = firstName
    self.lastName = lastName
    self.department = department
    self.title = title
    self.url = url
    
    // Creating a session object with the default configuration.
    // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
    let session = URLSession(configuration: .default)
    
    // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
    let downloadPicTask = session.dataTask(with: url) { [weak self] (data, response, error) in
      guard let strongSelf = self else {
        return
      }
      
      // The download has finished.
      if let e = error {
        print("Error downloading cat picture: \(e)")
      }
      else {
        // No errors found.
        // It would be weird if we didn't have a response, so check for that too.
        if let res = response as? HTTPURLResponse {
          print("Downloaded picture with response code \(res.statusCode)")
          if let imageData = data {
            // Finally convert that Data into an image and do what you wish with it.
            strongSelf.🖼 = UIImage(data: imageData)
            // Do something with your image.
          }
          else {
            print("Couldn't get image: Image is nil")
          }
        }
        else {
          print("Couldn't get response code for some reason")
        }
      }
    }
    
    downloadPicTask.resume()
  }
  
  static func loadFromWeb(completion: @escaping ([Employee]?) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      completion(loadEmployees())
    }
  }
}

private func loadEmployees() -> [Employee]? {
  guard let 🚩 = URL(string: "https://gizmo-app-backend.herokuapp.com/team") else { return nil }
  guard let 💾 = try? Data(contentsOf: 🚩) else { return nil }
  let json = try? JSONSerialization.jsonObject(with: 💾)
  guard let jsonEmployees = json as? [Any] else { return nil }
  
  var 👥 = [Employee]()
  for jsonEmployee in jsonEmployees {
    guard let employeeDict = jsonEmployee as? NSDictionary else { continue }
    guard let name = employeeDict["name"] as? String else { continue }
    let splitName = name.components(separatedBy: CharacterSet.whitespaces)
    guard let photoString = employeeDict["photo"] as? String else { continue }
    guard let photoURL = URL(string: photoString) else { continue }
    guard let department = employeeDict["team"] as? String else { continue }
    guard let title = employeeDict["role"] as? String else { continue }
    👥.append(Employee(firstName: splitName[0],
                         lastName: splitName[1],
                         department: department,
                         title: title,
                         url: photoURL))
  }
  
  return 👥
}
