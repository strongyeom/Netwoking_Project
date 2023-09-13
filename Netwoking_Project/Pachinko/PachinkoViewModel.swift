//
//  PachinkoViewModel.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/13.
//

import Foundation

class PachinkoViewModel {
    
    
    var firstNumber = Observable(1)
    var secondNumber = Observable("2")
    var thirdNumber = Observable("3")
    var fourthNumber = Observable("4")
    var fifthNumber = Observable("5")
    var sixthNumber = Observable("6")
    var bnusNumber = Observable("7")
    var lottoMoney = Observable("당첨금")
    
    
    func formatter(_ number:Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: number) ?? "0"
    }
    
    func presentFormatter() {
        guard let totalMoney = Int(lottoMoney.value) else { return }
        lottoMoney.value = formatter(totalMoney)
    }
    
    func fetchLottoAPI(drwNo: Int) {
        LottoAPIManager.shared.callRequest(selectedNumber: drwNo) { lotto in
            guard let lotto else { return }
            
            self.firstNumber.value = lotto.drwtNo1
            self.secondNumber.value = "\(lotto.drwtNo2)"
            self.thirdNumber.value = "\(lotto.drwtNo3)"
            self.fourthNumber.value = "\(lotto.drwtNo4)"
            self.fifthNumber.value = "\(lotto.drwtNo5)"
            self.sixthNumber.value = "\(lotto.drwtNo6)"
            self.bnusNumber.value = "\(lotto.bnusNo)"
            self.lottoMoney.value = self.formatter(lotto.firstWinamnt) + "원"
        }
    }
    
    
}
