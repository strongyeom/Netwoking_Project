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

class BeerDetailViewController: UIViewController {
    
    // static let identifier = "BeerDetailViewController"
    
    var clickCellStatus: ClickCellStatus = .tableSelected
    
    @IBOutlet var randomBtn: UIButton!
    
    @IBOutlet var beerImage: UIImageView!
    
    @IBOutlet var beerTitle: UILabel!
    
    @IBOutlet var titleBorderLineView: UIView!
    
    @IBOutlet var borderLineView: UIView!
    
    var beer: Beer?
    
    @IBOutlet var beerDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("clickCellStatus : \(clickCellStatus)")
        settingInitial(data: beer)
        self.randomBtn.addTarget(self, action: #selector(randomBtnClicked(_:)), for: .touchUpInside)
        
        switch clickCellStatus {
        case .collectionSelected:
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftBtnClicked(_:)))
        case .tableSelected:
            print("!23")
        }
    }
    
    @objc func leftBtnClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func settingInitial(data: Beer?) {
        guard let data else { return }
        let imageUrl = URL(string: data.ImageUrl)
        
        self.beerImage.kf.setImage(with: imageUrl)
        self.beerTitle.text = "제목 : \(data.title)"
        self.beerDescription.text = data.description
       
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
