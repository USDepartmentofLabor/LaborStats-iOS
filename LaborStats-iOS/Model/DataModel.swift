//
//  DataModel.swift
//  LaborStats-iOS
//
//  Created by Hari Yerramsetty on 9/25/18.
//  Copyright © 2018 Hari Yerramsetty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataModel {
    let url: String = "https://api.dol.gov/V1/statistics/BLS_Numbers/"
    let apiKey: String = "6770cb1656424f8eaa5d24596919bd56"
    let year: String
    let month: String
    let tableName: String
    
    init(tableName: String, year: String, month: String) {
        self.tableName = tableName
        self.year = year
        self.month = month
    }
    
    
    //MARK: Networking

    //TODO: Add completion handlers to handle the return value output from the Alamofire request
    func makeApiCall(completion: @escaping (Double) -> Void) {
        let urlWithFilters = "\(self.url)\(self.tableName)?KEY=\(self.apiKey)&$filter=(year eq \(self.year) and period lt \(self.month))"
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let encodedUrl = urlWithFilters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(encodedUrl!, headers: headers).responseJSON { response in
                        if response.result.isSuccess {
                            let jsonData: JSON = JSON(response.result.value!)
                            let responseArray  = jsonData["d"]["results"]
                            let lastObject = responseArray[responseArray.count - 1]
                            completion(lastObject["value"].doubleValue)
            }
            
        }
    }
    
}
