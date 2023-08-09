//
//  CollectionReusableView.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/10.
//

import UIKit

class CollectionViewFooterView: UICollectionReusableView {
    
    static let identifier = "CollectionReusableView"
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
