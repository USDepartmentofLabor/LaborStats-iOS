//
//  CurrentNumbersViewController.swift
//  LaborStats-iOS
//
//  Created by Hari Yerramsetty on 9/10/18.
//  Copyright © 2018 Hari Yerramsetty. All rights reserved.
//

import UIKit

class CurrentNumbersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Create a reference for the tableview inside view controller
    @IBOutlet weak var numbersTableView: UITableView!
    
    let list = ["Consumer Price Index", "Unemployment Rate", "Average Hourly Earning", "Producer Price Index", "Employment Cost Index", "Productivity", "US Import Price Index", "US Export Price Index"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* When the current view controller conforms to UITableViewDelegate and UITableViewDataSource protocol we to set current view controller as the delegate and dataSource for these protocols */
        
        numbersTableView.delegate = self
        numbersTableView.dataSource = self
    }

    //MARK: TableView delegate methods
    
    
    // This delegate function returns how many number of cells do we need in a table cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "numbersCell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    
    

}
