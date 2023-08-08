//
//  Ext+UILabel.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit

extension UILabel {
    func settingRandomAD() {
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
    }
    
    func randomBgColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .green,
            .yellow,
            .blue
        ]
        return colors.randomElement()!
    }
}
