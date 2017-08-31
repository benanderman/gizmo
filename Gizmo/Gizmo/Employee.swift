//
//  Employee.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import Foundation

struct Employee {
  let firstName: String
  let lastName: String
  let department: String
  let title: String
  let url: URL
  
  static func loadFromWeb(completion: @escaping ([Employee]?) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      completion(loadEmployees())
    }
  }
}

private func loadEmployees() -> [Employee]? {
  guard let 🚩 = URL(string: "https://www.shopspring.com/team.json") else { return nil }
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
