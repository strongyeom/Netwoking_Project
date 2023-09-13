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
    
    let pachincoViewModel = PachinkoViewModel()
    
    @IBOutlet var lottoNumbers: [UILabel]!
    
    @IBOutlet var gameStartBtn: UIButton!
    
    @IBOutlet var countLotto: UILabel!
    
    // 로또 횟차 생성
    let creatLottoCount = Array(Array(0...1000).reversed())
    
    @IBOutlet var praticeLabel: UILabel!
    
    @IBOutlet var lottoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingInitial()
        settingTextField()
        settingViewModel()
    }
    
    func settingViewModel() {
        pachincoViewModel.firstNumber.bind { number in
            self.lottoNumbers[0].text = "\(number)"
        }
        pachincoViewModel.secondNumber.bind { number in
            self.lottoNumbers[1].text = number
        }
        
        pachincoViewModel.thirdNumber.bind { number in
            self.lottoNumbers[2].text = number
        }
        
        pachincoViewModel.fourthNumber.bind { number in
            self.lottoNumbers[3].text = number
        }
        
        pachincoViewModel.fifthNumber.bind { number in
            self.lottoNumbers[4].text = number
        }
        
        pachincoViewModel.sixthNumber.bind { number in
            self.lottoNumbers[5].text = number
        }
        
        pachincoViewModel.bnusNumber.bind { number in
            self.lottoNumbers[6].text = number
        }
        
        pachincoViewModel.lottoMoney.bind { number in
            self.lottoNumbers[7].text = number
        }
    }
    
    func settingInitial() {
        self.praticeLabel.text = "연습게임"
        countLotto.text = "해당 회차 로또 번호"
        gameStartBtn.addTarget(self, action: #selector(gameStartBtnClicked(_:)), for: .touchUpInside)
        picker.dataSource = self
        picker.delegate = self
    }
    
    @objc func gameStartBtnClicked(_ sender: UIButton) {
        
        print(#fileID, #function, #line,"- <#comment#>" )
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: GameViewController.identifier) as? GameViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func tapGestureClicked(_ sender: UITapGestureRecognizer) {
        lottoTextField.text = ""
        view.endEditing(true)
    }
    
    
    func settingTextField() {
        self.lottoTextField.inputView = picker
        self.lottoTextField.placeholder = "확인하고 싶은 로또 회차를 입력해주세요"
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
        pachincoViewModel.fetchLottoAPI(drwNo: selectedNumber)
        countLotto.text = "\(selectedNumber)회차 로또 번호"
    }
}
