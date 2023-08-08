//
//  BeerViewController.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class BeerViewController: UIViewController {
    
    @IBOutlet var randomBtn: UIButton!
    
    @IBOutlet var beerImage: UIImageView!
    
    @IBOutlet var beerTitle: UILabel!
    
    @IBOutlet var titleBorderLineView: UIView!
    
    @IBOutlet var borderLineView: UIView!
    
    @IBOutlet var beerDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingInitial()
       
        
        self.randomBtn.addTarget(self, action: #selector(randomBtnClicked(_:)), for: .touchUpInside)
    }
    
    func settingInitial() {
        self.beerImage.image = UIImage(named: "beerImage")
        
        self.beerTitle.text = "제목"
        self.beerDescription.text = "내용"
       
        self.beerDescription.numberOfLines = 5
        self.beerDescription.font = UIFont.systemFont(ofSize: 13, weight: .light)
        titleBorderLineView.borderLine()
        borderLineView.borderLine()
    }
    
    @objc func randomBtnClicked(_ sender: UIButton) {
        callRequest()
    }
    
    
    
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let image = json[0]["image_url"].stringValue
                let imageUrl = URL(string: image)
                
                let description = json[0]["description"].stringValue
                let name = json[0]["name"].stringValue
                
                
                self.beerDescription.text = description
                self.beerTitle.text = "제목 : \(name)"
                self.beerImage.kf.setImage(with: imageUrl)
                
                if imageUrl == nil {
                    self.beerImage.image = UIImage(named: "beerImage")
                }
                
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
}
