//
//  Ext+TextField.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/05.
//

import UIKit

extension UITextView {
    
    func settingTextView(text: String?) {
        self.text = text
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
}
