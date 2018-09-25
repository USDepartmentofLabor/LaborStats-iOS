//
//  CurrentNumbersViewController.swift
//  LaborStats-iOS
//
//  Created by Hari Yerramsetty on 9/10/18.
//  Copyright © 2018 Hari Yerramsetty. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CurrentNumbersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Create a reference for the tableview inside view controller
    @IBOutlet weak var numbersTableView: UITableView!
    
    //MARK: CONSTANTS
    
    // Constant that holds label names that is displayed in the table cell
    let list = ["Consumer Price Index", "Unemployment Rate", "Average Hourly Earning", "Producer Price Index", "Employment Cost Index", "Productivity", "US Import Price Index", "US Export Price Index"]

    // List of all the tables to get the data from
    let tablesList = ["consumerPriceIndex1MonthChange",
                   "unemploymentRate",
                   "averageHourlyEarnings1MonthNetChange",
                   "producerPriceIndex",
                   "employmentCostIndex",
                   "productivity",
                   "importPriceIndex",
                   "exportPriceIndex"
    ]
    
    // This array holds the values of all the arrays
    var apiValues = [String]()
    
    // Activity Indicator
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    
    // This function is called when the view loads up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* When the current view controller conforms to UITableViewDelegate and UITableViewDataSource protocol we to set current view controller as the delegate and dataSource for these protocols */
        
        numbersTableView.delegate = self
        numbersTableView.dataSource = self
        
        // Create a datamodel object with the URL and make API request
        let datamodel = DataModel(tableName: tablesList[0], year: "2018", month: "9")
        datamodel.makeApiCall() { response in
            print(response)
        }
    }
    
    //MARK: TableView delegate methods
    
    
    // This delegate function returns how many number of cells do we need in a table cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // This delegate method returns what the cell in a table should contain
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "numbersCell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    // This delegate method is to perform what should happen when a cell is pressed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        dvc.getnumberName = "passing text"
    }
    

}
