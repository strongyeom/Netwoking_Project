//
//  NetworkManager.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/13.
//

import Foundation
import Alamofire

class LottoAPIManager {
    static let shared = LottoAPIManager()
    
    private init() { }
    
    func callRequest(selectedNumber: Int, completionHandler: @escaping (Lotto?) -> Void) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(selectedNumber)"
        
        AF.request(url, method: .get).validate()
            .responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    completionHandler(data)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
