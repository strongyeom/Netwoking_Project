//
//  ReuseIdentiferCell.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/04.
//

import UIKit

protocol ReuseIdentiferCell {
    static var identifier : String { get }
}

extension UIViewController : ReuseIdentiferCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentiferCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView : ReuseIdentiferCell {
    static var identifier: String {
        return String(describing: self)
    }
}


