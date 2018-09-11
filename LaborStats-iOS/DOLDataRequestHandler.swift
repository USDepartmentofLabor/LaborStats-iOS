//
//  DOLDataRequestHandler.swift
//  LaborStats-iOS
//
//  Created by Hari Yerramsetty on 9/10/18.
//  Copyright © 2018 Hari Yerramsetty. All rights reserved.
//
/* This class is reponsible for making API call to DOL API v2 */

import Foundation
import Alamofire
import SwiftyJSON

class DOLDataRequestHandler {
    
    //MARK: DOLDataRequestHandler Properties
    
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    var returnValue: Double = 0.0
    let URL: String
    //var API_KEY: String

    init(URL: String) {
        self.URL = URL
    }
    
    func makeAPICall() {
        // Using Alamofire to make a API Call
        let url = self.URL
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(encodedUrl!, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                let jsonData: JSON = JSON(response.result.value!)
                if jsonData["d"]["results"] != JSON.null {
                    let responseArray  = jsonData["d"]["results"]
                    let latestRecord   = responseArray[responseArray.count - 1]["value"]
                    print(latestRecord)
                }
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    
    
    
}
