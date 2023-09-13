//
//  NetworkManager.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/14.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    var beerList: [Beer] = []
    
    // 네트워크 통신
    func callRequest(completionHandler: @escaping(([Beer]) -> Void)) {
        
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json.arrayValue {
                    
                    let imageData = item["image_url"].stringValue
                    let title = item["name"].stringValue
                    let description = item["description"].stringValue
                    let data = Beer(ImageUrl: imageData, title: title, description: description)
                    self.beerList.append(data)
                }
                completionHandler(self.beerList)
                
               // self.tableView.reloadData()
               // self.collectionView.reloadData()
               // print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
}
