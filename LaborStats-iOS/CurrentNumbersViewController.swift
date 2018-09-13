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
    
    // APIV1 url for BLS Numbers
    let apiURL = "https://api.dol.gov/V1/statistics/BLS_Numbers/"
    
    // APIV1 key to fetch data
    let apiKey = "6770cb1656424f8eaa5d24596919bd56"
    
    // Constant that holds label names that is displayed in the table cell
    let list = ["Consumer Price Index", "Unemployment Rate", "Average Hourly Earning", "Producer Price Index", "Employment Cost Index", "Productivity", "US Import Price Index", "US Export Price Index"]
    
    let urlList = ["consumerPriceIndex1MonthChange",
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
    
    
    // This function is called when the view loads up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* When the current view controller conforms to UITableViewDelegate and UITableViewDataSource protocol we to set current view controller as the delegate and dataSource for these protocols */
        
        numbersTableView.delegate = self
        numbersTableView.dataSource = self
        loadData()
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
    
    //MARK: Networking
    
    func loadData() {
        for url in urlList {
            let newURL = "\(apiURL)\(url)?KEY=\(apiKey)&$filter=(year eq 2018 and period lt 9)"
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            let encodedUrl = newURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            Alamofire.request(encodedUrl!, headers: headers).responseJSON { response in
                if response.result.isSuccess {
                    let jsonData: JSON = JSON(response.result.value!)
                    let responseArray  = jsonData["d"]["results"]
                    let lastObject = responseArray[responseArray.count - 1]
                    self.addValueToAPIValues(lastObject["value"].doubleValue)
                    self.numbersTableView.reloadData()
                }
            }
        }
    }
    
    func addValueToAPIValues(_ value: Double) { apiValues.append(String(value)) }

    
    
    
    

}
