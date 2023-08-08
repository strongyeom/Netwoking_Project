//
//  GameViewController.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire

class GameViewController: UIViewController {
    
    static let identifier = "GameViewController"

    var timer: Timer!
    
    var countArray: [Int] = Array(0...100)
    
    var exampleCollection: [Int] = []
    
    let adText: [String] = [
        "가입시 코인 3배 지급!!", "정품 인증 사이트!!", "역배 최대 300%지급 ", "새싹은 내가 지킨다"
    ]
    
    @IBOutlet var adTextCollection: [UILabel]!
    
    @IBOutlet var pachincoResult: [UILabel]!
    
    @IBOutlet var resultTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pachincoResult.forEach { textLabel in
            textLabel.settingRandomAD()
        }
        resultTextLabel.text = "행운의 777을 잡아라!"
        resultTextLabel.settingRandomAD()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.setRandomBackgroundColor), userInfo: nil, repeats: true)
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        print("sender \(sender.tag)")
       
        callRequest(btn: sender)
        

       
    }
    
    func callRequest(btn: UIButton) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(countArray.randomElement()!)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let number1 = json["drwtNo1"].intValue
                let number2 = json["drwtNo2"].intValue
                let number3 = json["drwtNo3"].intValue
                
                
                self.exampleCollection.append(contentsOf: [number1, number2, number3])
                self.pachincoResult[btn.tag].text = "\(self.exampleCollection[btn.tag])"
             
                if self.pachincoResult[btn.tag].text == "7" {
                    self.pachincoResult[btn.tag].textColor = .orange
                }
        
                self.exampleCollection = []
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func setRandomBackgroundColor() {
        
        print("타이머 시작")
        
        for i in 0..<adTextCollection.count {
            adTextCollection[i].settingRandomAD()
            
            adTextCollection[i].backgroundColor =   adTextCollection[i].randomBgColor()
            adTextCollection[i].text = adText[i]
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("GVC - viewWillDisappear")
        print("타이머 중지")
        timer.invalidate()
    }
  
}
