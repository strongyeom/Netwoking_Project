//
//  PachinkoViewController.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class PachinkoViewController: UIViewController {
    
    var selectedNumber: Int = 0
    
    let picker = UIPickerView()
    
    @IBOutlet var lottoNumbers: [UILabel]!
    
    @IBOutlet var countLotto: UILabel!
    
    // 해당 회차 로또 담기
    var createdLottoNumber: [Int] = []
    
    // 로또 횟차 생성
    let creatLottoCount = Array(Array(0...1010).reversed())
    
    @IBOutlet var praticeLabel: UILabel!
    
    @IBOutlet var lottoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.praticeLabel.text = "연습게임"
        picker.dataSource = self
        picker.delegate = self
        settingTextField()
        countLotto.text = "해당 회차 로또 번호"
        settingNumber()
    }

    func settingNumber() {
        for index in 0..<lottoNumbers.count {
            lottoNumbers[index].text = "\(index+1)번 번호"
            lottoNumbers[index].font = UIFont.systemFont(ofSize: 11)
        }
    }
    
    
    
    
    
    @IBAction func tapGestureClicked(_ sender: UITapGestureRecognizer) {
        lottoTextField.text = ""
        view.endEditing(true)
    }
    
    
    func settingTextField() {
        self.lottoTextField.inputView = picker
        self.lottoTextField.placeholder = "확인하고 싶은 로또 회차를 입력해주세요"
    }
    
    func callRequest() {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(selectedNumber)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let number1 = json["drwtNo1"].intValue
                let number2 = json["drwtNo2"].intValue
                let number3 = json["drwtNo3"].intValue
                let number4 = json["drwtNo4"].intValue
                let number5 = json["drwtNo5"].intValue
                let number6 = json["drwtNo6"].intValue
                let bnusNumber = json["bnusNo"].intValue
                
                
                self.createdLottoNumber.append(contentsOf: [number1,
                                                  number2,
                                                  number3,
                                                  number4,
                                                  number5,
                                                  number6,
                                                  bnusNumber])
                
                for i in 0..<self.createdLottoNumber.count {
                    self.lottoNumbers[i].text = "\(self.createdLottoNumber[i])"
                    self.lottoNumbers[i].textAlignment = .center
                    self.lottoNumbers[i].font = UIFont.systemFont(ofSize: 17, weight: .medium)
                }
                // 적용 후 비워주기
                self.createdLottoNumber = []
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension PachinkoViewController: UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return creatLottoCount.count
    }
    
}

extension PachinkoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(creatLottoCount[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("picker 눌림 \(creatLottoCount[row])")
        lottoTextField.text = "\(creatLottoCount[row])"
        selectedNumber = creatLottoCount[row]
        print("selectedNumber",selectedNumber)
        callRequest()
        countLotto.text = "\(selectedNumber)회차 로또 번호"
    }
}
