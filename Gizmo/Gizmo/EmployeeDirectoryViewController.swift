//
//  EmployeeDirectoryViewController.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 9/1/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit

class EmployeeDirectoryViewController: UIViewController {
  
  var employees: [Employee]!
  fileprivate var sections = [String]()
  fileprivate var employeeDict: [String: [Employee]] = [:]
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.employees.sort { (employee1, employee2) -> Bool in
      return employee1.alphabeticalName < employee2.alphabeticalName
    }
    
    var letterSet = Set<String>()
    for employee in self.employees {
      let firstChar: String = employee.lastName[0]
      letterSet.insert(firstChar)
      
      if employeeDict[firstChar] == nil {
        employeeDict[firstChar] = []
      }
      
      var array = employeeDict[firstChar]
      array?.append(employee)
      employeeDict[firstChar] = array;
    }
    
    sections = Array(letterSet).sorted()
    
    NotificationCenter.default.addObserver(self, selector: #selector(employeeImageDownloaded), name: .EmployeeImageDownloaded, object: nil)
  }
  
  @IBAction func homeButtonTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  func employeeImageDownloaded(notification: Notification) {
    guard let indexPaths = tableView.indexPathsForVisibleRows, let notificationEmployee = notification.object as? Employee else {
      return
    }
    
    var indexPathsToUpdate = [IndexPath]()
    for indexPath in indexPaths {
      let employee = employees[indexPath.row];
      if (employee.firstName == notificationEmployee.firstName) && (employee.lastName == notificationEmployee.lastName) {
        indexPathsToUpdate.append(indexPath)
      }
    }
    
    guard !indexPathsToUpdate.isEmpty else {
      return
    }
    
    tableView.reloadRows(at: indexPathsToUpdate, with: .fade)
  }
}

// MARK: - UITableViewDelegate
extension EmployeeDirectoryViewController: UITableViewDelegate {
  
}

// MARK: - UITableViewDataSource
extension EmployeeDirectoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let key = sections[section]
    guard let employeeList = employeeDict[key] else {
      return 0
    }
    
    return employeeList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath)
    
    let key = sections[indexPath.section]
    let employeeList = employeeDict[key]
    guard let employee = employeeList?[indexPath.row] else {
      return cell;
    }
    
    cell.imageView?.image = employee.🖼 == nil ? #imageLiteral(resourceName: "cat") : employee.🖼
    cell.textLabel?.text = "\(employee.alphabeticalName)"
    cell.detailTextLabel?.text = "\(employee.title)"
    
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return sections
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
  }
  
  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    let idx = sections.index(of: title)
    return idx!
  }
}

extension String {
  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  
  subscript (r: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
    return self[Range(start ..< end)]
  }
}
