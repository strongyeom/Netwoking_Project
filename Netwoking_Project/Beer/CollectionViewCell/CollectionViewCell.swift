//
//  CollectionViewCell.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "CollectionViewCell"
    @IBOutlet var headerCollImage: UIImageView!
    
    @IBOutlet var headerCollTitle: UILabel!
    
    @IBOutlet var headerCollDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
