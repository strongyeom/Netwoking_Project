//
//  KakaoCollectionViewCell.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/09.
//

import UIKit
import Kingfisher

class KakaoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "KakaoCollectionViewCell"
    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var bookname: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        bookImage.contentMode = .scaleAspectFill
        bookname.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    func configure(item : Document) {
        settingKingfisher(urlString: item.thumbnail)
        self.bookname.text = item.title
    }
    
    func settingKingfisher(urlString: String) {
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: bookImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        bookImage.kf.indicatorType = .activity
        bookImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }

}
