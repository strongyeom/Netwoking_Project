//
//  MyFavoriteBookTableViewCell.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/04.
//

import UIKit

class MyFavoriteBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookThumbnail: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        bookTitle.font = .systemFont(ofSize: 20, weight: .medium)
        bookPrice.font = .systemFont(ofSize: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
