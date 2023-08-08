//
//  Ext+UIView.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit

extension UIView {
    func borderLine() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
