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
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.employees.sort { (employee1, employee2) -> Bool in
      return employee1.alphabeticalName < employee2.alphabeticalName
    }
    
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

extension EmployeeDirectoryViewController: UITableViewDelegate {
  
}

extension EmployeeDirectoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return employees.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath)
    
    let employee = employees[indexPath.row]
    cell.imageView?.image = employee.🖼 == nil ? #imageLiteral(resourceName: "cat") : employee.🖼
    cell.textLabel?.text = "\(employee.alphabeticalName)"
    cell.detailTextLabel?.text = "\(employee.title)"
    
    return cell
  }
}
